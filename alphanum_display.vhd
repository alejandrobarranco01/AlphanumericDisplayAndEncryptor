LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alphanum_display IS
    PORT (
        sw  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Switches 0 through 7 (for 8-bit ASCII input)
        key3 : IN  STD_LOGIC; -- Switching between displays will be triggered by KEY3                   
        clk  : IN  STD_LOGIC;                     
        seg0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX0 
        seg1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX1
        seg2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX2
        seg3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX3
        seg4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- HEX4
        seg5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- HEX5
    );
END alphanum_display;

ARCHITECTURE behavior OF alphanum_display IS
	
	 -- Declare component for the button logic
	 COMPONENT button_logic IS 
		PORT (
            key : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            button_out : OUT STD_LOGIC); 
	 END COMPONENT;
	 
	 -- Declare component for the seven segment decoder logic
	 COMPONENT seven_segment_decoder IS
		PORT (
				sw       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); 
				seg_out  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	 END COMPONENT;
				

    -- Free Range VHDL book 11.6
	 -- Created a custom type to hold an array of 6 values, each value holds 7-bit vector
	 -- Gonna use it to store values for each seven-segment display
    TYPE display_array_t IS ARRAY (0 TO 5) OF STD_LOGIC_VECTOR(6 DOWNTO 0);
	 
	 -- Free Range VHDL book 3.4
	 -- Using these signal declarations because values will change between processes (serve a wire)
	 
	 -- Using this as a index for the displays, will limit it from
	 -- 0 to 5 and will start it off at HEX5
    SIGNAL display_index : INTEGER RANGE 0 TO 5 := 5;                
	 
	 -- Using this to store each individual seven-segment display value (7-bit vector)
    SIGNAL seg_values : STD_LOGIC_VECTOR(6 DOWNTO 0);                
	
	 -- Using this for my custom type and initializing all off them to be off 
    SIGNAL displays : display_array_t := (OTHERS => "1111111");      

	 -- Using this to keep track of each button presses
    SIGNAL button_press : STD_LOGIC;                                    

BEGIN
	-- Create instance of the button logic module
	-- Make sure we assign the correct values
	BUTTON_LOGIC_INSTANCE : button_logic 
		PORT MAP (key => key3,
					 clk => clk,
					 button_out => button_press);
					 
	-- Create instance of the seven segment decoder logic
	SEVEN_SEGMENT_DECODER_INSTANCE : seven_segment_decoder
		PORT MAP (sw => sw,
					 seg_out => seg_values);

   -- Handle button presses
   PROCESS (clk)
   BEGIN
		IF rising_edge(clk) THEN
			-- If KEY3 was pressed, decrement the index and make sure it stays in bounds
         IF button_press = '1' THEN
				display_index <= (display_index - 1);
				IF display_index <= 0 THEN
					display_index <= 5;
				END IF;
         END IF;
      END IF;
   END PROCESS;
		  
	-- Update current index every clock cycle during rising edge
   PROCESS (clk)
   BEGIN
		IF rising_edge(clk) THEN
			displays(display_index) <= seg_values;
      END IF;
   END PROCESS;
	 
	-- Assign each seven-segment display with the value at its corresponding value in the array
   seg0 <= displays(0);
   seg1 <= displays(1);
   seg2 <= displays(2);
   seg3 <= displays(3);
   seg4 <= displays(4);
	seg5 <= displays(5);

END behavior;
