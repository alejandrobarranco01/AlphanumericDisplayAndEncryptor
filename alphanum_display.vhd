LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.display_types.ALL;

ENTITY alphanum_display IS
	PORT (
		sw8 : IN STD_LOGIC; -- This will be used to toggle between View Mode and Modify Mode
		sw9 : IN STD_LOGIC; -- This will be used to enable the Encryption Mode
		sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Switches 0 through 7 (for 8-bit ASCII input)
		key3 : IN STD_LOGIC; -- Switching between displays will be triggered by KEY3

		key1 : IN STD_LOGIC; -- This is used for incrementing the value of the shift counter when Encryption Mode is on
		key0 : IN STD_LOGIC; -- This is used for resetting the value of the shift counter when Encryption Mode is on

		clk : IN STD_LOGIC; -- Clock signal
		seg0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX0
		seg1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX1
		seg2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX2
		seg3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX3
		seg4 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX4
		seg5 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- HEX5

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
	COMPONENT ascii_to_seven_segment IS
		PORT (
			sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			seg_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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

	-- Declare component for the shift counter
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

	-- Declare component for the encrypt module
	COMPONENT encrypt IS
		PORT (
			shift_value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ascii_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			ascii_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	CONSTANT OFF : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111111"; -- Value needed to turn off the display(s)

	-- Signals
	SIGNAL display_index : INTEGER RANGE 0 TO 5 := 5; -- Index for the displays, initialized to HEX5 (left to right)

	SIGNAL seg_values_array : display_array_t := (OTHERS => OFF); -- Array to  7-segment values for each display

	SIGNAL ascii_values_array : display_array_t; -- Array to store the ASCII values for each display
	SIGNAL encrypted_ascii_values_array : display_array_t; -- Array to store the encrypted ASCII values for each display

	SIGNAL encrypted_seg_values_array : display_array_t := (OTHERS => OFF); -- Array to store the encrypted 7-segment values for each display 

	SIGNAL button_press : STD_LOGIC; -- Signal to track button presses
	SIGNAL flash_value : STD_LOGIC; -- Signal for the flashing output clock (2 Hz)

	SIGNAL shift_value : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL seg_values : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
	-- Instantiate the button logic module
	BUTTON_LOGIC_INSTANCE : button_logic
	PORT MAP(
		key => key3,
		clk => clk,
		button_out => button_press
	);

	-- Instantiate the seven segment decoder module
	ASCII_TO_SEVEN_SEGMENT_INSTANCE : ascii_to_seven_segment
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

	-- Instantiate the shift counter module
	SHIFT_COUNTER_INSTANCE : shift_counter
	PORT MAP(
		sw9 => sw9,
		clk => clk,
		leds => leds,
		key1 => key1,
		key0 => key0,
		shift_value => shift_value
	);

	-- Here grab the values from the 7-segment displays and convert them back to their original ASCII values
	GEN_ORIGINAL_ASCII :
	FOR i IN 0 TO 5 GENERATE
	BEGIN
		SEVEN_SEGMENT_TO_ASCII_INST : ENTITY work.seven_segment_to_ascii
			PORT MAP(
				seg_values => seg_values_array(i),
				ascii_out => ascii_values_array(i)
			);
	END GENERATE GEN_ORIGINAL_ASCII;

	-- Here we generate the encrypted ASCII values from the original ASCII values using encrypt.v
	GEN_ENCRYPTED_ASCII :
	FOR i IN 0 TO 5 GENERATE
	BEGIN
		ENCRYPT_INST : encrypt
		PORT MAP(
			ascii_in => ascii_values_array(i),
			shift_value => shift_value,
			ascii_out => encrypted_ascii_values_array(i)

		);
	END GENERATE GEN_ENCRYPTED_ASCII;

	-- Here we convert the encrypted ASCII values to the correct 7-segment values and store them in the corresponding array
	GEN_ENCRYPTED_SEVEN_SEGMENT :
	FOR i IN 0 TO 5 GENERATE
	BEGIN ENCRYPTED_ASCII_TO_SEVEN_SEGMENT_INST : ENTITY work.ascii_to_seven_segment
		PORT MAP(
			sw => encrypted_ascii_values_array(i),
			seg_out => encrypted_seg_values_array(i)
		);
	END GENERATE GEN_ENCRYPTED_SEVEN_SEGMENT;

	-- Process to handle button presses and update displays
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF sw8 = '1' THEN
				-- If KEY3 is pressed, decrement the index and wrap around if necessary
				IF button_press = '1' THEN
					IF display_index = 0 THEN
						display_index <= 5; -- Wrap around to ==
					ELSE
						display_index <= display_index - 1; -- Decrement index
					END IF;
				END IF;
				-- Store the regular segment value in the array
				seg_values_array(display_index) <= seg_values;

			END IF;
		END IF;
	END PROCESS;

	-- Here we show the encrypted values when SW9 is up, otherwise show the regular values
	-- If SW8 is up, implement the flashing functionality 

	seg0 <= encrypted_seg_values_array(0) WHEN (sw9 = '1') ELSE
		seg_values_array(0) WHEN (display_index /= 0 OR -- Not the active display (not the one currently being changed)
		sw8 = '0' OR -- In View Mode
		flash_value = '1') -- Flashing clock is high
		ELSE
		OFF; -- Otherwise, turn off the display

	seg1 <= encrypted_seg_values_array(1) WHEN (sw9 = '1') ELSE
		seg_values_array(1) WHEN (display_index /= 1 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;

	seg2 <= encrypted_seg_values_array(2) WHEN (sw9 = '1') ELSE
		seg_values_array(2) WHEN (display_index /= 2 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;

	seg3 <= encrypted_seg_values_array(3) WHEN (sw9 = '1') ELSE
		seg_values_array(3) WHEN (display_index /= 3 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;

	seg4 <= encrypted_seg_values_array(4) WHEN (sw9 = '1') ELSE
		seg_values_array(4) WHEN (display_index /= 4 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;

	seg5 <= encrypted_seg_values_array(5) WHEN (sw9 = '1') ELSE
		seg_values_array(5) WHEN (display_index /= 5 OR sw8 = '0' OR flash_value = '1') ELSE
		OFF;

END behavior;