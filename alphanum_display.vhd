LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.display_types.ALL;

ENTITY alphanum_display IS
    PORT (
        sw8 : IN STD_LOGIC; -- Toggle between View Mode and Modify Mode
        sw9 : IN STD_LOGIC; -- Enable Encryption Mode

        sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- ASCII input

        key3 : IN STD_LOGIC; -- Switch between displays
        key1 : IN STD_LOGIC; -- Increment shift counter
        key0 : IN STD_LOGIC; -- Reset shift counter

        clk : IN STD_LOGIC; -- Clock signal

        seg0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX0
        seg1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX1
        seg2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX2
        seg3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX3
        seg4 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX4
        seg5 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX5

        leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- Shift amount
    );
END alphanum_display;

ARCHITECTURE behavior OF alphanum_display IS
    COMPONENT button_logic IS
        PORT (
            key : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            button_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT ascii_to_seven_segment IS
        PORT (
            sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            seg_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT clock_divider IS
        PORT (
            sw8 : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            clk_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT shift_counter IS
        PORT (
            sw9 : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            key0 : IN STD_LOGIC;
            key1 : IN STD_LOGIC;
            leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            shift_value : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT encrypt IS
        PORT (
            shift_value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            ascii_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            ascii_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT OFF : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111111"; -- Value for displays to be off (Active Low)

    SIGNAL display_index : INTEGER RANGE 0 TO 5 := 5; -- Active display index (HEX5 to HEX0)

    SIGNAL ascii_values_array : display_array_t := (OTHERS => (OTHERS => '0')); -- Stores ASCII values
    SIGNAL encrypted_ascii_values_array : display_array_t; -- Encrypted ASCII values

    SIGNAL regular_seg_values_array : display_array_t; -- Seven-segment for regular ASCII
    SIGNAL encrypted_seg_values_array : display_array_t := (OTHERS => OFF); -- Seven-segment for encrypted ASCII

    SIGNAL button_press : STD_LOGIC; -- Debounced button press
    SIGNAL flash_value : STD_LOGIC; -- 2Hz clock for flashing
    SIGNAL shift_value : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Current shift amount

BEGIN
    -- Button press detection for KEY3
    BUTTON_LOGIC_INSTANCE : button_logic
    PORT MAP(
        key => key3,
        clk => clk,
        button_out => button_press
    );

    -- Clock divider for display flashing
    CLOCK_DIVIDER_INSTANCE : clock_divider
    PORT MAP(
        sw8 => sw8,
        clk => clk,
        clk_out => flash_value
    );

    -- Shift counter for encryption
    SHIFT_COUNTER_INSTANCE : shift_counter
    PORT MAP(
        sw9 => sw9,
        clk => clk,
        key0 => key0,
        key1 => key1,
        leds => leds,
        shift_value => shift_value
    );

    -- Convert stored ASCII values to seven-segment
    GEN_REGULAR_SEVEN_SEGMENT : FOR i IN 0 TO 5 GENERATE
        REGULAR_SEG_CONV : ascii_to_seven_segment
        PORT MAP(
            sw => ascii_values_array(i),
            seg_out => regular_seg_values_array(i)
        );
    END GENERATE;

    -- Encrypt ASCII values and convert to seven-segment
    GEN_ENCRYPTED_ASCII : FOR i IN 0 TO 5 GENERATE
        ENCRYPT_INST : encrypt
        PORT MAP(
            ascii_in => ascii_values_array(i),
            shift_value => shift_value,
            ascii_out => encrypted_ascii_values_array(i)
        );
        ENCRYPTED_SEG_CONV : ascii_to_seven_segment
        PORT MAP(
            sw => encrypted_ascii_values_array(i),
            seg_out => encrypted_seg_values_array(i)
        );
    END GENERATE;

    -- Update displays and stored ASCII values
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF sw8 = '1' THEN -- Modify Mode
                -- Update display index on button press
                IF button_press = '1' THEN
                    display_index <= (display_index - 1) MOD 6;
                END IF;
                -- Store current ASCII input into active display position
                ascii_values_array(display_index) <= sw;
            END IF;
        END IF;
    END PROCESS;

    -- Display output logic with flashing
    seg0 <= encrypted_seg_values_array(0) WHEN sw9 = '1' ELSE
        regular_seg_values_array(0) WHEN (display_index /= 0 OR sw8 = '0' OR flash_value = '1') ELSE
        OFF;

    seg1 <= encrypted_seg_values_array(1) WHEN sw9 = '1' ELSE
        regular_seg_values_array(1) WHEN (display_index /= 1 OR sw8 = '0' OR flash_value = '1') ELSE
        OFF;

    seg2 <= encrypted_seg_values_array(2) WHEN sw9 = '1' ELSE
        regular_seg_values_array(2) WHEN (display_index /= 2 OR sw8 = '0' OR flash_value = '1') ELSE
        OFF;

    seg3 <= encrypted_seg_values_array(3) WHEN sw9 = '1' ELSE
        regular_seg_values_array(3) WHEN (display_index /= 3 OR sw8 = '0' OR flash_value = '1') ELSE
        OFF;

    seg4 <= encrypted_seg_values_array(4) WHEN sw9 = '1' ELSE
        regular_seg_values_array(4) WHEN (display_index /= 4 OR sw8 = '0' OR flash_value = '1') ELSE
        OFF;

    seg5 <= encrypted_seg_values_array(5) WHEN sw9 = '1' ELSE
        regular_seg_values_array(5) WHEN (display_index /= 5 OR sw8 = '0' OR flash_value = '1') ELSE
        OFF;

END behavior;