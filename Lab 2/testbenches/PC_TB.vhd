LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY test_pc IS END test_pc;

ARCHITECTURE behavioural OF test_pc IS
    COMPONENT PC_16 PORT (
        clk  : in  std_logic;
        con  : in  std_logic_vector(1 downto 0);
        pc_i : in  std_logic_vector(15 downto 0);
        pc_o : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    SIGNAL clk : STD_LOGIC;
    SIGNAL con : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL pc_i, pc_o : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0000";
BEGIN
    u0 : PC_16 PORT MAP(clk, con, pc_i, pc_o);
    PROCESS BEGIN
        clk <= '0';
        WAIT FOR 10 us;
        clk <= '1';
        WAIT FOR 10 us;
    END PROCESS;
    PROCESS BEGIN
        con <= "00";
        pc_i <= X"0000";
        WAIT UNTIL (rising_edge(clk));
        assert (pc_o = X"0001") report "output wrong 0";
        WAIT UNTIL (rising_edge(clk));
        assert (pc_o = X"0002") report "output wrong 1";
        WAIT UNTIL (rising_edge(clk));
        assert (pc_o = X"0003") report "output wrong 2";
        WAIT UNTIL (rising_edge(clk));
        assert (pc_o = X"0004") report "output wrong 3";
        con <= "01";
        WAIT UNTIL (rising_edge(clk));
        assert (pc_o = X"0004") report "output wrong 4";
        con <= "10";
        pc_i <= X"5555";
        WAIT UNTIL (rising_edge(clk));
        assert (pc_o = X"5556") report "output wrong 5";
        con <= "11";
        WAIT UNTIL (rising_edge(clk));
        assert (pc_o = X"0000") report "output wrong 6";
        con <= "00";        
        WAIT;
    END PROCESS;
END behavioural;