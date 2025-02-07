LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.display_types.ALL;

ENTITY alphanum_display IS
	PORT (
		sw8 : IN STD_LOGIC; -- This will be used to toggle between View Mode and Modify Mode
		sw9 : IN STD_LOGIC; -- This will be used to enable the encryption mode
		sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Switches 0 through 7 (for 8-bit ASCII input)
		key3 : IN STD_LOGIC; -- Switching between displays will be triggered by KEY3

		key1 : IN STD_LOGIC;
		key0 : IN STD_LOGIC;

		clk : IN STD_LOGIC; -- Clock signal
		seg0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX0
		seg1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX1
		seg2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX2
		seg3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX3
		seg4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX4
		seg5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX5

		leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- Used to show shift amount
	);
END alphanum_display;

ARCHITECTURE behavior OF alphanum_display IS

	-- Declare component for the button logic
	COMPONENT button_logic IS
		PORT (
			key : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			button_out : OUT STD_LOGIC
		);
	END COMPONENT;

	-- Declare component for the seven segment decoder logic
	COMPONENT seven_segment_decoder IS
		PORT (
			sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			seg_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

	-- Declare component for the clock divider
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

	-- Custom type to hold an array of 6 values, each value is a 7-bit vector
	--TYPE display_array_t IS ARRAY (0 TO 5) OF STD_LOGIC_VECTOR(6 DOWNTO 0);

	CONSTANT OFF : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111"; -- All segments off

	-- Signals
	SIGNAL display_index : INTEGER RANGE 0 TO 5 := 5; -- Index for the displays, initialized to HEX5
	SIGNAL seg_values : STD_LOGIC_VECTOR(6 DOWNTO 0); -- Decoded 7-segment value
	SIGNAL displays : display_array_t := (OTHERS => OFF); -- Array to store display values
	SIGNAL button_press : STD_LOGIC; -- Signal to track button presses
	SIGNAL flash_value : STD_LOGIC; -- Signal for the flashing output clock (2 Hz)

BEGIN
	-- Instantiate the button logic module
	BUTTON_LOGIC_INSTANCE : button_logic
	PORT MAP(
		key => key3,
		clk => clk,
		button_out => button_press
	);

	-- Instantiate the seven segment decoder module
	SEVEN_SEGMENT_DECODER_INSTANCE : seven_segment_decoder
	PORT MAP(
		sw => sw,
		seg_out => seg_values
	);
	-- Instantiate the clock divider module
	CLOCK_DIVIDER_INSTANCE : clock_divider
	PORT MAP(
		sw8 => sw8,
		clk => clk,
		clk_out => flash_value
	);

	SHIFT_COUNTER_INSTANCE : shift_counter
	PORT MAP(
		sw9 => sw9,
		clk => clk,
		leds => leds,
		key1 => key1,
		key0 => key0
	);

	-- Process to handle button presses and update displays
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF sw8 = '1' THEN
				-- If KEY3 is pressed, decrement the index and wrap around if necessary
				IF button_press = '1' THEN
					IF display_index = 0 THEN
						display_index <= 5; -- Wrap around to HEX5
					ELSE
						display_index <= display_index - 1; -- Decrement index
					END IF;
				END IF;
				-- Update the current display with the decoded value
				displays(display_index) <= seg_values;
			END IF;
		END IF;
	END PROCESS;

	seg0 <= displays(0) WHEN (display_index /= 0 OR -- Not the active display (not the one currently being changed)
		sw8 = '0' OR -- In View Mode
		flash_value = '1') -- Flashing clock is high
		ELSE
		OFF; -- Otherwise, turn off the display	
	seg1 <= displays(1) WHEN (display_index /= 1 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;
	seg2 <= displays(2) WHEN (display_index /= 2 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;
	seg3 <= displays(3) WHEN (display_index /= 3 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;
	seg4 <= displays(4) WHEN (display_index /= 4 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;
	seg5 <= displays(5) WHEN (display_index /= 5 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;
END behavior;