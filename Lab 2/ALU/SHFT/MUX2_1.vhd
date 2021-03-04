-- Aman Nijjar

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MUX2_1 IS
   PORT (
      SEL : IN STD_LOGIC;
      A   : IN STD_LOGIC;
      B   : IN STD_LOGIC;
      C   : OUT STD_LOGIC
   );
END MUX2_1;

ARCHITECTURE behavioural OF MUX2_1 IS
BEGIN
   C <= A WHEN (SEL = '1') ELSE B;
END behavioural;