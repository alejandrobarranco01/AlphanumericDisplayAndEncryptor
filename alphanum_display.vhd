LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.display_types.ALL;
USE work.state_type_pkg.ALL;

ENTITY alphanum_display IS
    PORT (
        sw8 : IN STD_LOGIC; -- Toggle between View Mode and Modify Mode
        sw9 : IN STD_LOGIC; -- Enable Encryption Mode

        sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- ASCII input via switches SW0-SW7

        key3 : IN STD_LOGIC; -- Switch between displays
        key2 : IN STD_LOGIC; -- Decrement shift counter
        key1 : IN STD_LOGIC; -- Increment shift counter
        key0 : IN STD_LOGIC; -- Reset shift counter

        clk : IN STD_LOGIC; -- Clock signal

        seg0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX0
        seg1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX1
        seg2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX2
        seg3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX3
        seg4 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX4
        seg5 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX5

        leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- Displays shift amount
    );
END alphanum_display;

ARCHITECTURE behavior OF alphanum_display IS
    -- Button Logic Component Declaration
    -- This component implements debouncing logic for button input
    COMPONENT button_logic IS
        PORT (
            key : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            button_out : OUT STD_LOGIC
        );
    END COMPONENT;

    -- ASCII-to-Seven-Segment Component Declaration
    -- This component converts an 8-bit ASCII character to an 8-bit Seven-Segment display pattern
    COMPONENT ascii_to_seven_segment IS
        PORT (
            ascii_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            seg_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    -- Clock Divider Component Declaration
    -- This component generates a 2 Hz clock signal from a 50 MHz system clock
    COMPONENT clock_divider IS
        PORT (
            sw8 : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            clk_out : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Caesar Shift Counter Component Declaration
    -- This component tracks a counter for a Caesar shift with the ability
    -- to increment, decrement, and reset the counter
    COMPONENT shift_counter IS
        PORT (
            sw9 : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            key0 : IN STD_LOGIC;
            key1 : IN STD_LOGIC;
            key2 : IN STD_LOGIC;
            leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            shift_value : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    -- Encryption Component Declaration
    -- This component applies a Caesar shift on an ASCII value based on a shift value
    COMPONENT encrypt IS
        PORT (
            shift_value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            ascii_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            ascii_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    -- Decryption Component Declaration
    -- This component reverses a Caesar shift on an ASCII value based on a shift value
    COMPONENT decrypt IS
        PORT (
            shift_value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            ascii_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            ascii_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT OFF : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111111"; -- Value for displays to be off (Active Low)
    CONSTANT NONE : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000"; -- Value for a null ASCII character 

    SIGNAL display_index : INTEGER RANGE 0 TO 5 := 5; -- Active display index (HEX5 to HEX0)

    SIGNAL ascii_values_array : display_array_t := (OTHERS => NONE); -- Stores user ASCII values (6 by 8 bits)
    SIGNAL encrypted_ascii_values_array : display_array_t; -- Stores encrypted ASCII values (6 by 8 bits)
    SIGNAL decrypted_ascii_values_array : display_array_t; -- Stores decrypted ASCII values (6 by 8 bits)

    SIGNAL regular_seg_values_array : display_array_t; -- Stores user seven-segment display values
    SIGNAL encrypted_seg_values_array : display_array_t := (OTHERS => OFF); -- Stores encrypted seven-segment display values
    SIGNAL decrypted_seg_values_array : display_array_t := (OTHERS => OFF); -- Stores decrypted seven-segment display values

    SIGNAL button_press : STD_LOGIC; -- Debounced button press
    SIGNAL flash_value : STD_LOGIC; -- 2Hz clock output for flashing
    SIGNAL shift_value : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Current shift amount

    SIGNAL mode : state; -- The current state of the application (VIEW_MODE, MODIFY_MODE, ENCRYPTION_MODE, DECRYPTION_MODE)

    SIGNAL sw9_sync, sw8_sync : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00"; -- Switch Synchronization -> 2-bit Buffer

    SIGNAL clk_div_enable : STD_LOGIC; -- Enable clock divider only in MODIFY_MODE (for display flashing)
    SIGNAL shift_counter_enable : STD_LOGIC; -- Enables shift counter in ENCRYPTION_MODE & DECRYPTION_MODE
BEGIN
    -- Enable clock divider only in MODIFY_MODE (for display flashing)
    clk_div_enable <= '1' WHEN mode = MODIFY_MODE ELSE
        '0';

    -- Enable shift counter only in ENCRYPTION_MODE & DECRYPTION_MODE
    shift_counter_enable <= '1' WHEN (mode = ENCRYPTION_MODE OR mode = DECRYPTION_MODE) ELSE
        '0';

    -- Button debouncer for KEY3 to cycle through displays in MODIFY_MODE
    BUTTON_LOGIC_INSTANCE : button_logic
    PORT MAP(
        key => key3,
        clk => clk,
        button_out => button_press
    );

    -- Clock Divider for display flashing in MODIFY_MODE
    CLOCK_DIVIDER_INSTANCE : clock_divider
    PORT MAP(
        sw8 => clk_div_enable,
        clk => clk,
        clk_out => flash_value
    );

    -- Shift Counter for Caesar Cipher
    SHIFT_COUNTER_INSTANCE : shift_counter
    PORT MAP(
        sw9 => shift_counter_enable,
        clk => clk,
        key0 => key0,
        key1 => key1,
        key2 => key2,
        leds => leds,
        shift_value => shift_value
    );

    -- Generate seven-segment displays for user inputted ASCII values
    GEN_REGULAR_SEVEN_SEGMENT : FOR i IN 0 TO 5 GENERATE
        REGULAR_SEG_CONV : ascii_to_seven_segment
        PORT MAP(
            ascii_in => ascii_values_array(i),
            seg_out => regular_seg_values_array(i)
        );
    END GENERATE;

    -- Generate encrypted ASCII and corresponding seven-segment displays
    GEN_ENCRYPTED_ASCII : FOR i IN 0 TO 5 GENERATE
        ENCRYPT_INST : encrypt
        PORT MAP(
            ascii_in => ascii_values_array(i),
            shift_value => shift_value,
            ascii_out => encrypted_ascii_values_array(i)
        );
        ENCRYPTED_SEG_CONV : ascii_to_seven_segment
        PORT MAP(
            ascii_in => encrypted_ascii_values_array(i),
            seg_out => encrypted_seg_values_array(i)
        );
    END GENERATE;

    -- Generate decrypted ASCII and corresponding seven-segment displays
    GEN_DECRYPTED_ASCII : FOR i IN 0 TO 5 GENERATE
        DECRYPT_INST : decrypt
        PORT MAP(
            ascii_in => ascii_values_array(i),
            shift_value => shift_value,
            ascii_out => decrypted_ascii_values_array(i)
        );
        DECRYPTED_SEG_CONV : ascii_to_seven_segment
        PORT MAP(
            ascii_in => decrypted_ascii_values_array(i),
            seg_out => decrypted_seg_values_array(i)
        );
    END GENERATE;

    -- Synchronize switches sw9 and sw8 to avoid metastability
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            -- sw9_sync(0) old sample
            -- sw9 raw input
            -- Concatenate
            -- Read from bit1 sw9_sync(1) for more stable value
            -- Allows for signal to settle over 2 clock cycles
            sw9_sync <= sw9_sync(0) & sw9; -- Double-flop sync for sw9
            sw8_sync <= sw8_sync(0) & sw8; -- Double-flop sync for sw8
        END IF;
    END PROCESS;

    -- Decode system mode from synchronized switches
    PROCESS (clk)
        VARIABLE switch_pair : STD_LOGIC_VECTOR(1 DOWNTO 0);
    BEGIN
        IF rising_edge(clk) THEN
            switch_pair := sw9_sync(1) & sw8_sync(1); -- Combined switch state
            CASE switch_pair IS
                WHEN "00" => mode <= VIEW_MODE; -- View stored ASCII values
                WHEN "01" => mode <= MODIFY_MODE; -- Edit ASCII values
                WHEN "10" => mode <= ENCRYPTION_MODE; -- Show encrypted text
                WHEN "11" => mode <= DECRYPTION_MODE; -- Show decrypted text
                WHEN OTHERS => mode <= VIEW_MODE; -- Default/Fallback
            END CASE;
        END IF;
    END PROCESS;

    -- Handle ASCII input and display selection in MODIFY_MODE
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF mode = MODIFY_MODE THEN -- Modify Mode
                -- Update display index on button press
                IF button_press = '1' THEN
                    display_index <= (display_index - 1) MOD 6;
                END IF;
                -- Store current ASCII input into active display position
                ascii_values_array(display_index) <= sw;
            END IF;
        END IF;
    END PROCESS;

    -- Display output logic 
    seg0 <= decrypted_seg_values_array(0) WHEN mode = DECRYPTION_MODE ELSE
        encrypted_seg_values_array(0) WHEN mode = ENCRYPTION_MODE ELSE
        regular_seg_values_array(0) WHEN (mode = VIEW_MODE) ELSE
        regular_seg_values_array(0) WHEN (display_index /= 0 OR flash_value = '1') ELSE
        OFF;

    seg1 <= decrypted_seg_values_array(1) WHEN mode = DECRYPTION_MODE ELSE
        encrypted_seg_values_array(1) WHEN mode = ENCRYPTION_MODE ELSE
        regular_seg_values_array(1) WHEN (mode = VIEW_MODE) ELSE
        regular_seg_values_array(1) WHEN (display_index /= 1 OR flash_value = '1') ELSE
        OFF;

    seg2 <= decrypted_seg_values_array(2) WHEN mode = DECRYPTION_MODE ELSE
        encrypted_seg_values_array(2) WHEN mode = ENCRYPTION_MODE ELSE
        regular_seg_values_array(2) WHEN (mode = VIEW_MODE) ELSE
        regular_seg_values_array(2) WHEN (display_index /= 2 OR flash_value = '1') ELSE
        OFF;

    seg3 <= decrypted_seg_values_array(3) WHEN mode = DECRYPTION_MODE ELSE
        encrypted_seg_values_array(3) WHEN mode = ENCRYPTION_MODE ELSE
        regular_seg_values_array(3) WHEN (mode = VIEW_MODE) ELSE
        regular_seg_values_array(3) WHEN (display_index /= 3 OR flash_value = '1') ELSE
        OFF;

    seg4 <= decrypted_seg_values_array(4) WHEN mode = DECRYPTION_MODE ELSE
        encrypted_seg_values_array(4) WHEN mode = ENCRYPTION_MODE ELSE
        regular_seg_values_array(4) WHEN (mode = VIEW_MODE) ELSE
        regular_seg_values_array(4) WHEN (display_index /= 4 OR flash_value = '1') ELSE
        OFF;

    seg5 <= decrypted_seg_values_array(5) WHEN mode = DECRYPTION_MODE ELSE
        encrypted_seg_values_array(5) WHEN mode = ENCRYPTION_MODE ELSE
        regular_seg_values_array(5) WHEN (mode = VIEW_MODE) ELSE
        regular_seg_values_array(5) WHEN (display_index /= 5 OR flash_value = '1') ELSE
        OFF;

END behavior;