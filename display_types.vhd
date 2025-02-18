LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE display_types IS
	TYPE display_array_t IS ARRAY (0 TO 5) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
END PACKAGE;