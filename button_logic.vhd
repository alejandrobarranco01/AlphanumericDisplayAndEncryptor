LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY button_logic IS
    PORT (
        key      : IN  STD_LOGIC; -- Generic key input 
        clk       : IN  STD_LOGIC; -- We need this because the clock will synchronize the detection of the button press so it doesn't miss it
        button_out : OUT STD_LOGIC -- This will just output if a button was pressed or not
    );
END button_logic;

ARCHITECTURE behavior OF button_logic IS
    SIGNAL prev_state : STD_LOGIC := '1';  -- Set previous state of key as 1 (just to start out cycle)
BEGIN

    -- Check every rising edge of clock cycle
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
				-- If the key went from being being unpressed to pressed, then set ouput value to 1 (true, pressed)
            IF (key = '1') AND (prev_state = '0') THEN
                button_out <= '1';
				-- All other cases, just set output value to 0 (false, not pressed) 
            ELSE
                button_out <= '0';  -- No button press
            END IF;
            prev_state <= key;  -- Update the previous state of key
        END IF;
    END PROCESS;

END behavior;