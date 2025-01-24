LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY seven_segment_decoder IS
    PORT (
        sw       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); 
        seg_out  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  
    );
END seven_segment_decoder;

ARCHITECTURE behavior OF seven_segment_decoder IS
BEGIN
    PROCESS (sw)
        VARIABLE H : STD_LOGIC := sw(0); -- SW0
        VARIABLE G : STD_LOGIC := sw(1); -- SW1
        VARIABLE F : STD_LOGIC := sw(2); -- SW2
        VARIABLE E : STD_LOGIC := sw(3); -- SW3
        VARIABLE D : STD_LOGIC := sw(4); -- SW4
        VARIABLE C : STD_LOGIC := sw(5); -- SW5
        VARIABLE B : STD_LOGIC := sw(6); -- SW6
        VARIABLE A : STD_LOGIC := sw(7); -- SW7
    BEGIN
        seg_out(0) <=  not ((not A and not B and C and D and not E and F and H) or (not A and not B and C and D and not E and G) or (not A and not B and C and D and E and not F and not G) or (not A and B and not D and not E and F and G) or (not A and B and not D and G and H) or (not A and B and not D and F and H) or (not A and B and D and not E and not F and not G) or (not A and B and not E and not F and H) or (not A and B and D and E and not F and G and not H) or (not A and not B and C and D and not E and not F and not H));
        seg_out(1) <= not ((not A and not B and C and D and not E and not F) or (not A and not B and C and D and not E and not G and not H) or (not A and C and D and not F and not G) or (not A and B and not F and not G and H) or (not A and B and not D and not E and F and not G and not H) or (not A and B and E and not F and G and not H) or (not A and B and not D and E and F and G and H) or (not A and B and D and not F and not G) or (not A and B and D and not E and F and H) or (not A and not B and C and D and not E and G and H));
        seg_out(2) <= not ((not A and B and not F and not G and H) or (not A and B and not D and not F and G and not H) or (not A and B and not D and not E and F and not G and not H) or (not A and B and not D and F and G and H) or (not A and B and not D and E and H) or (not A and B and not D and E and G) or (not A and B and D and not E and not F and H) or (not A and B and D and not E and not G and H) or (not A and B and D and not E and F and G and not H) or (not A and B and E and not F and not G) or (not A and not B and C and D and not F and not G) or (not A and not B and C and D and not E and H) or (not A and not B and C and D and not E and F));
        seg_out(3) <= not ((not A and C and D and not E and F and not G and H) or (not A and not B and C and D and not E and G and not H) or (not A and B and not D and F and not G and not H) or (not A and B and not D and F and G and H) or (not A and B and not E and G and H) or (not A and B and not E and F and not G) or (not A and B and D and E and not F and not G and H) or (not A and B and E and not F and G and not H) or (not A and not B and C and D and not E and not F and not H) or (not A and not B and C and D and not E and not F and G) or (not A and not B and C and D and E and not F and not G) or (not A and B and not D and not E and not F and G));
        seg_out(4) <= not ((not A and C and D and not E and G and not H) or (not A and C and D and not F and not G and not H) or (not A and B and not D and not E and H) or (not A and B and not D and G) or (not A and B and not D and F) or (not A and B and not E and F and not G) or (not A and B and E and not F and not H) or (not A and B and D and not E and not H));
        seg_out(5) <= not ((not A and C and D and not E and F and not G) or (not A and not B and C and D and not E and F and not H) or (not A and C and D and E and not F and not G) or (not A and B and not E and H) or (not A and B and not D and not E and G) or (not A and B and not D and G and H) or (not A and B and not D and E and not G and not H) or (not A and B and D and not E and not G) or (not A and B and D and not F and not G) or (not A and C and D and not E and not G and not H));
        seg_out(6) <=  not ((not A and C and D and not E and not F and G) or (not A and not B and C and D and not E and F and not G) or (not A and C and D and E and not F and not G) or (not A and B and not D and not E and F) or (not A and B and E and not F and not G and not H) or (not A and B and not D and E and not F and G and H) or (not A and B and not D and F and G and not H) or (not A and B and D and not E and not F) or (not A and B and D and not F and not G) or (not A and B and D and not F and not H) or (not A and not B and C and D and not E and G and not H) or (not A and B and not D and not E and not G and H) or (not A and B and not D and not E and G and not H) or (not A and B and not E and F and not G and not H));
    END PROCESS;
END behavior;
