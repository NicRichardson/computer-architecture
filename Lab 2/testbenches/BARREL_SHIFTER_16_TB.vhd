LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY BARREL_SHIFTER_TB IS
   --  Port ( );
END BARREL_SHIFTER_TB;

ARCHITECTURE Behavioral OF BARREL_SHIFTER_TB IS
   -- RBS signals
   SIGNAL BARREL_SHIFTER_A : STD_LOGIC_VECTOR (15 DOWNTO 0);
   SIGNAL BARREL_SHIFTER_B : STD_LOGIC_VECTOR (3 DOWNTO 0);
   SIGNAL BARREL_SHIFTER_LEFT : STD_LOGIC;
   SIGNAL BARREL_SHIFTER_Y : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

   BARREL_SHIFTER : ENTITY work.BARREL_SHIFTER_16 PORT MAP(BARREL_SHIFTER_A, BARREL_SHIFTER_B, BARREL_SHIFTER_LEFT, BARREL_SHIFTER_Y);
   
   BARREL_SHIFTER_TESTS : PROCESS
      CONSTANT period : TIME := 20 ns;
      CONSTANT direction : STD_LOGIC := '1'; -- 0 == RIGHT
   BEGIN
      -- 0 bit shift case
      BARREL_SHIFTER_A <= X"FFFF";
      BARREL_SHIFTER_B <= "0000";
      BARREL_SHIFTER_LEFT <= direction;
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_Y = X"FFFF") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 16 bit shift" SEVERITY failure;
      -- 1 bit shift case
      BARREL_SHIFTER_A <= X"FFFF";
      BARREL_SHIFTER_B <= "0001";
      BARREL_SHIFTER_LEFT <= direction;
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_Y = X"FFFE")--BARREL_SHIFTER_Y = X"7FFF") -- expected output
      REPORT "test failed for 1 bit shift" SEVERITY failure;

      -- 2 bit shift case
      BARREL_SHIFTER_A <= X"FFFF";
      BARREL_SHIFTER_B <= "0010";
      BARREL_SHIFTER_LEFT <= direction;
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_Y = X"FFFC")--BARREL_SHIFTER_Y = X"3FFF") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 2 bit shift" SEVERITY failure;

      -- 4 bit shift case
      BARREL_SHIFTER_A <= X"FFFF";
      BARREL_SHIFTER_B <= "0100";
      BARREL_SHIFTER_LEFT <= direction;
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_Y = X"FFF0"--BARREL_SHIFTER_Y = X"0FFF") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 4 bit shift" SEVERITY failure;
      
      -- 8 bit shift case
      BARREL_SHIFTER_A <= X"FFFF";
      BARREL_SHIFTER_B <= "1000";
      BARREL_SHIFTER_LEFT <= direction;
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_Y = X"FF00")--BARREL_SHIFTER_Y = X"00FF") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 8 bit shift" SEVERITY failure;
      
      -- 16 bit shift case
      BARREL_SHIFTER_A <= X"FFFF";
      BARREL_SHIFTER_B <= "1111";
      BARREL_SHIFTER_LEFT <= direction;
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_Y = X"8000"--BARREL_SHIFTER_Y = X"0001") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 16 bit shift" SEVERITY failure;

      WAIT;
   END PROCESS;
END Behavioral;