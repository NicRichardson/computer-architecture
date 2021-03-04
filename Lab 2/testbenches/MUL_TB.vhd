-- Aman Nijjar

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUL_TB IS
   --  Port ( );
END MUL_TB;

ARCHITECTURE Behavioral OF MUL_TB IS
   SIGNAL MUL_M : STD_LOGIC_VECTOR (15 DOWNTO 0);
   SIGNAL MUL_R : STD_LOGIC_VECTOR (15 DOWNTO 0);
   SIGNAL MUL_RESULT : STD_LOGIC_VECTOR (15 DOWNTO 0);
   SIGNAL MUL_O_FLAG : STD_LOGIC;
BEGIN

   MUL : ENTITY work.MUL GENERIC MAP(n => 16) PORT MAP(MUL_M, MUL_R, MUL_RESULT, MUL_O_FLAG);
   
   MUL_TESTS : PROCESS
      CONSTANT period : TIME := 20 ns;
   BEGIN
      -- 1 x 1
      MUL_M <= X"0001";
      MUL_R <= X"0001";
      WAIT FOR period;
      ASSERT (MUL_RESULT = X"0001") -- expected output
      REPORT "test failed for 1x1" SEVERITY failure;

      -- 2 x 2
      MUL_M <= X"0002";
      MUL_R <= X"0002";
      WAIT FOR period;
      ASSERT (MUL_RESULT = X"0004") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 2 x 2" SEVERITY failure;

      -- 5 x -5
      MUL_M <= X"0005";
      MUL_R <=  X"FFFB";
      WAIT FOR period;
      ASSERT (MUL_RESULT = X"FFE7") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 5 x -5" SEVERITY failure;
      
      -- 180 x -170
      MUL_M <= X"00B4";
      MUL_R <= X"FF56";
      WAIT FOR period;
      ASSERT (MUL_RESULT = X"8878") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 180 x -170 " SEVERITY failure;
      
      -- 32,767 x 32,767 (error case)
      MUL_M <= X"7FFF";
      MUL_R <= X"7FFF";
      WAIT FOR period;
      ASSERT (MUL_RESULT = X"0001") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 180 x -170 (error case)" SEVERITY failure;
      

      
      -- 32,767 x 32,767 (error case)
      MUL_M <= X"23FF";
      MUL_R <= X"0000";
      WAIT FOR period;
      ASSERT (MUL_RESULT = X"0000") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 180 x -170 (error case)" SEVERITY failure;
      
       -- 32,767 x 32,767 (error case)
      MUL_M <= X"FFFF";
      MUL_R <= X"FFFF";
      WAIT FOR period;
      ASSERT (MUL_RESULT = X"FFFF") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for 180 x -170 (error case)" SEVERITY failure;
      WAIT;
   END PROCESS;
END Behavioral;