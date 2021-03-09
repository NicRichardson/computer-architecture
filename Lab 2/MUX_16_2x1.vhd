LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MUX_16_2x1 IS
   PORT (
      SEL : IN  std_logic;
      A   : IN  std_logic_vector(15 downto 0);
      B   : IN  std_logic_vector(15 downto 0);
      C   : OUT std_logic_vector(15 downto 0)
   );
END MUX_16_2x1;

ARCHITECTURE behavioural OF MUX_16_2x1 IS
BEGIN
   C <= A WHEN (SEL = '0') ELSE B;
END behavioural;