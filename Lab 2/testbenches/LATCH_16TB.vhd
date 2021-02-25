LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY test_latch IS END test_latch;

ARCHITECTURE behavioural OF test_latch IS
    COMPONENT LATCH_16 PORT (
        rst    : IN  STD_LOGIC;
        clk    : IN  STD_LOGIC;
        in_a : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_a : out STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL rst, clk : STD_LOGIC;
    SIGNAL in_a, out_a : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    u0 : LATCH_16 PORT MAP(rst, clk, in_a, out_a);
    PROCESS BEGIN
        clk <= '0';
        WAIT FOR 10 us;
        clk <= '1';
        WAIT FOR 10 us;
    END PROCESS;
    PROCESS BEGIN
        rst <= '1';
        in_a <= X"0000";
        WAIT UNTIL (clk = '1' AND clk'event);
        WAIT UNTIL (clk = '0' AND clk'event);
        rst <= '0';
        WAIT UNTIL (clk = '0' AND clk'event);
        assert (out_a = X"0000") report "output wrong 0";
        in_a <= X"AAAA";
        WAIT UNTIL (clk = '0' AND clk'event);
        assert (out_a = X"AAAA") report "output wrong 1";
        in_a <= X"5555";
        WAIT UNTIL (clk = '0' AND clk'event);
        assert (out_a = X"5555") report "output wrong 2";
        WAIT;
    END PROCESS;
END behavioural;