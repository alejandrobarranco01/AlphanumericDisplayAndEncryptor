LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY shift_counter IS
    PORT (
        sw9 : IN STD_LOGIC; -- ENCRYPTION_MODE & DECRYPTION_MODE Toggle
        clk : IN STD_LOGIC;
        key0 : IN STD_LOGIC; -- This will reset the counter
        key1 : IN STD_LOGIC; -- This will increment the counter
        key2 : IN STD_LOGIC; -- This will decrement the counter
        leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- This will display the value of the counter
        shift_value : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- This will represent the shift amount
    );
END shift_counter;

ARCHITECTURE behavior OF shift_counter IS
    SIGNAL counter : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0'); -- Create an array of values for counter, all 0 at first

    -- Debounced output signals from button logic modules
    SIGNAL key0_out : STD_LOGIC;
    SIGNAL key1_out : STD_LOGIC;
    SIGNAL key2_out : STD_LOGIC;

BEGIN

    -- Instantiate button logic for key0
    key0_logic : ENTITY work.button_logic
        PORT MAP(
            key => key0,
            clk => clk,
            button_out => key0_out
        );

    -- Instantiate button logic for key1
    key1_logic : ENTITY work.button_logic
        PORT MAP(
            key => key1,
            clk => clk,
            button_out => key1_out
        );

    -- Instantiate button logic for key2
    key2_logic : ENTITY work.button_logic
        PORT MAP(
            key => key2,
            clk => clk,
            button_out => key2_out
        );

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            -- Operate only when in ENCRYPTION_MODE & DECRYPTION_MODE  (SW9SW8 -> 10, 11)
            IF sw9 = '1' THEN
                -- Reset counter if key0 was pressed
                IF key0_out = '1' THEN
                    counter <= (OTHERS => '0');
                END IF;

                -- Increment counter if key1 was pressed
                IF key1_out = '1' THEN
                    counter <= counter + 1;
                END IF;

                -- Decrement the counter if key2 was pressed
                IF key2_out = '1' THEN
                    -- Only decrement if the counter value is greater than 0
                    IF counter > 0 THEN
                        counter <= counter - 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Display the counter value on the LEDs only when in ENCRYPTION_MODE & DECRYPTION_MODE  (SW9SW8 -> 10, 11)
    leds <= STD_LOGIC_VECTOR(counter) WHEN sw9 = '1' ELSE
        (OTHERS => '0');

    -- Always output the current counter value as the shift value
    shift_value <= STD_LOGIC_VECTOR(counter);

END behavior;