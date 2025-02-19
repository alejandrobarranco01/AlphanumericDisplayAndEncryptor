LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY seven_segment_to_ascii IS
    PORT (
        seg_values : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        ascii_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END seven_segment_to_ascii;

ARCHITECTURE logic OF seven_segment_to_ascii IS
BEGIN
    PROCESS(seg_values)
        VARIABLE a : STD_LOGIC := seg_values(0);
        VARIABLE b : STD_LOGIC := seg_values(1);
        VARIABLE c : STD_LOGIC := seg_values(2);
        VARIABLE d : STD_LOGIC := seg_values(3);
        VARIABLE e : STD_LOGIC := seg_values(4);
        VARIABLE f : STD_LOGIC := seg_values(5);
        VARIABLE g : STD_LOGIC := seg_values(6);
        VARIABLE h : STD_LOGIC := seg_values(7);
    BEGIN
        ascii_out(0) <= ((NOT h AND NOT g AND NOT f AND NOT e AND NOT d AND c AND NOT b AND NOT a) OR (NOT h AND NOT g AND NOT f AND e AND NOT d AND c AND NOT b AND a) OR (NOT h AND NOT g AND f AND NOT e AND d AND NOT c AND b AND NOT a) OR (NOT h AND f AND e AND d AND NOT c AND NOT b AND a) OR (NOT h AND NOT g AND f AND e AND d AND c AND b AND NOT a) OR (NOT h AND g AND NOT f AND e AND d AND c AND NOT b AND NOT a) OR (NOT h AND g AND f AND NOT d AND c AND b AND a) OR (NOT h AND g AND f AND NOT e AND d AND c AND b AND NOT a) OR (h AND NOT g AND NOT f AND NOT e AND NOT d AND c AND b) OR (h AND g AND NOT e AND d AND c AND b AND a) OR (g AND f AND NOT e AND d AND c AND NOT b AND a) OR (NOT h AND g AND f AND e AND c AND NOT b AND a));
        ascii_out(1) <= ((NOT h AND NOT f AND e AND NOT d AND c AND NOT b AND NOT a) OR (NOT h AND NOT g AND NOT f AND e AND d AND c AND b AND NOT a) OR (NOT h AND NOT g AND f AND NOT e AND d AND NOT c AND b AND NOT a) OR (NOT h AND NOT g AND f AND e AND d AND NOT c AND NOT b AND a) OR (NOT h AND g AND NOT f AND e AND NOT d AND NOT b AND NOT a) OR (g AND NOT f AND e AND d AND NOT c AND b AND a) OR (NOT h AND g AND f AND d AND c AND NOT b AND a) OR (NOT h AND g AND f AND e AND NOT d AND NOT b AND a) OR (h AND NOT g AND NOT f AND NOT e AND NOT d AND c AND b AND a) OR (h AND g AND NOT f AND NOT e AND d AND c AND b AND a) OR (g AND f AND e AND d AND c AND NOT b AND a) OR (NOT h AND g AND e AND d AND c AND NOT b AND NOT a));
        ascii_out(2) <= ((NOT h AND NOT g AND NOT f AND e AND NOT d AND c AND NOT b) OR (NOT h AND NOT g AND f AND NOT e AND d AND NOT c AND b AND NOT a) OR (NOT h AND f AND e AND d AND NOT c AND NOT b AND NOT a) OR (NOT h AND NOT g AND f AND e AND d AND c AND b AND NOT a) OR (NOT h AND g AND NOT f AND e AND d AND c AND NOT a) OR (NOT h AND g AND f AND e AND NOT c AND NOT b AND a) OR (h AND NOT g AND NOT f AND NOT e AND NOT d AND c AND b AND a) OR (h AND g AND f AND NOT e AND NOT d AND c AND b AND NOT a) OR (h AND g AND f AND d AND c AND NOT b AND a) OR (NOT h AND NOT f AND e AND NOT d AND c AND NOT b AND NOT a) OR (NOT h AND g AND f AND e AND d AND NOT b AND a));
        ascii_out(3) <= ((NOT h AND NOT g AND NOT f AND NOT e AND NOT d AND c AND NOT b AND NOT a) OR (NOT h AND NOT g AND NOT f AND e AND NOT d AND c AND NOT b AND a) OR (NOT h AND NOT g AND NOT f AND e AND d AND c AND b AND NOT a) OR (NOT h AND NOT g AND f AND e AND d AND NOT c AND NOT b AND NOT a) OR (NOT h AND g AND NOT f AND e AND d AND NOT c AND b AND a) OR (NOT h AND g AND NOT f AND e AND c AND NOT b AND NOT a) OR (NOT h AND g AND f AND NOT e AND d AND c AND b AND NOT a) OR (NOT h AND g AND f AND e AND NOT d AND c AND NOT b) OR (NOT h AND g AND f AND e AND NOT d AND c AND NOT a) OR (h AND g AND f AND d AND c AND b AND a));

        ascii_out(4) <= ((NOT h AND NOT g AND NOT f AND e AND NOT d AND c AND NOT b AND NOT a) OR (NOT h AND NOT g AND f AND NOT e AND d AND NOT c AND b AND NOT a) OR (NOT h AND NOT g AND f AND e AND d AND c AND b AND NOT a) OR (NOT h AND g AND NOT f AND e AND NOT d AND NOT c AND NOT b AND NOT a) OR (g AND NOT f AND e AND d AND NOT c AND b AND a) OR (NOT h AND g AND f AND NOT e AND NOT d AND c AND b AND a) OR (g AND f AND NOT e AND d AND c AND NOT b AND a) OR (NOT h AND g AND f AND NOT e AND d AND c AND b AND NOT a) OR (NOT h AND g AND f AND e AND NOT d AND NOT c AND b AND a) OR (NOT h AND g AND f AND e AND NOT d AND c AND b AND NOT a) OR (NOT h AND g AND f AND e AND d AND NOT c AND NOT b AND NOT a) OR (h AND NOT g AND NOT f AND NOT e AND NOT d AND c AND b) OR (h AND f AND e AND d AND c AND b AND a) OR (h AND g AND NOT e AND d AND c AND b AND a) OR (h AND g AND f AND NOT e AND NOT d AND c AND b AND NOT a) OR (h AND g AND f AND d AND c AND a));
        ascii_out(5) <= ((NOT h AND NOT g AND NOT f AND NOT d AND c AND NOT b AND NOT a) OR (NOT h AND NOT g AND NOT f AND e AND NOT d AND c AND NOT b) OR (NOT h AND NOT g AND f AND NOT e AND d AND NOT c AND b AND NOT a) OR (NOT h AND f AND e AND d AND NOT c AND NOT b) OR (NOT h AND NOT g AND e AND d AND c AND b AND NOT a) OR (NOT h AND g AND NOT f AND e AND NOT d AND NOT b AND NOT a) OR (g AND NOT f AND e AND d AND NOT c AND b AND a) OR (NOT h AND g AND f AND NOT d AND c AND b AND a) OR (g AND f AND d AND c AND NOT b AND a) OR (NOT h AND g AND f AND NOT e AND d AND c AND b AND NOT a) OR (NOT h AND g AND f AND e AND NOT d AND a) OR (NOT h AND g AND f AND e AND NOT d AND c) OR (h AND NOT g AND NOT f AND NOT e AND NOT d AND c AND b) OR (h AND f AND e AND d AND c AND b AND a) OR (h AND g AND NOT e AND d AND c AND b AND a) OR (h AND g AND f AND NOT e AND NOT d AND c AND b AND NOT a) OR (NOT h AND g AND NOT f AND e AND d AND c AND NOT a) OR (NOT h AND g AND e AND c AND NOT b AND NOT a));
        ascii_out(6) <= ((NOT h AND NOT g AND NOT f AND NOT d AND c AND NOT b AND NOT a) OR (NOT h AND NOT g AND NOT f AND e AND NOT d AND c AND NOT b) OR (NOT h AND NOT g AND f AND NOT e AND d AND NOT c AND b AND NOT a) OR (NOT h AND f AND e AND d AND NOT c AND NOT b) OR (NOT h AND NOT g AND e AND d AND c AND b AND NOT a) OR (NOT h AND g AND NOT f AND e AND NOT d AND NOT b AND NOT a) OR (NOT h AND g AND NOT f AND e AND d AND NOT c AND b AND a) OR (NOT h AND g AND f AND NOT d AND c AND b AND a) OR (NOT h AND g AND f AND d AND c AND NOT b AND a) OR (NOT h AND g AND f AND NOT e AND d AND c AND b AND NOT a) OR (NOT h AND g AND f AND e AND NOT d AND a) OR (NOT h AND g AND f AND e AND NOT d AND c) OR (NOT h AND g AND NOT f AND e AND d AND c AND NOT a) OR (NOT h AND g AND e AND c AND NOT b AND NOT a));
        ascii_out(7) <= '0';
    END PROCESS;
END logic;