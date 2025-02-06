LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY clock_divider IS
	PORT (
		sw8 : IN STD_LOGIC; -- 
		clk : IN STD_LOGIC; -- Input clock (50 MHz)
		clk_out : OUT STD_LOGIC -- Output clock (2 Hz)
	);
END clock_divider;

ARCHITECTURE behavior OF clock_divider IS
	CONSTANT max_value : INTEGER := 25000000; -- Since we're making a 2 Hz clock, our max will be 50 MHz / 2 Hz = 25000000
	SIGNAL counter : INTEGER RANGE 0 TO max_value - 1 := 0;
	SIGNAL flash_state : STD_LOGIC := '0';
BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF sw8 = '1' THEN -- Remember this only works if SW8 is up (Modify Mode)
				IF counter = max_value - 1 THEN
					counter <= 0; -- Reset the counter
					flash_state <= NOT flash_state; -- Toggle flash state
				ELSE
					counter <= counter + 1; -- Increment counter
				END IF;
			ELSE
				flash_state <= '0'; -- No flash state change when SW8 is down (View Mode)
			END IF;
		END IF;
	END PROCESS;

	clk_out <= flash_state; -- Make the clock output happen everytime we toggle
END behavior;