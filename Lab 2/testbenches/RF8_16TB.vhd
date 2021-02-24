LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY test_rf IS END test_rf;

ARCHITECTURE behavioural OF test_rf IS
    COMPONENT register_file PORT (rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rd_index1, rd_index2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        rd_data1, rd_data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        wr_index : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        wr_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        wr_enable : IN STD_LOGIC);
    END COMPONENT;
    SIGNAL rst, clk, wr_enable : STD_LOGIC;
    SIGNAL rd_index1, rd_index2, wr_index : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL rd_data1, rd_data2, wr_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    u0 : register_file PORT MAP(rst, clk, rd_index1, rd_index2, rd_data1, rd_data2, wr_index, wr_data, wr_enable);
    PROCESS BEGIN
        clk <= '0';
        WAIT FOR 10 us;
        clk <= '1';
        WAIT FOR 10 us;
    END PROCESS;
    PROCESS BEGIN
        rst <= '1';
        rd_index1 <= "000";
        rd_index2 <= "000";
        wr_enable <= '0';
        wr_index <= "000";
        wr_data <= X"0000";
        WAIT UNTIL (clk = '0' AND clk'event);
        WAIT UNTIL (clk = '1' AND clk'event);
        rst <= '0';
        WAIT UNTIL (clk = '1' AND clk'event);
        wr_enable <= '1';
        wr_data <= X"200a";
        WAIT UNTIL (clk = '1' AND clk'event);
        wr_index <= "001";
        wr_data <= X"0037";
        WAIT UNTIL (clk = '1' AND clk'event);
        wr_index <= "010";
        wr_data <= X"8b00";
        WAIT UNTIL (clk = '1' AND clk'event);
        wr_index <= "101";
        wr_data <= X"f00d";
        WAIT UNTIL (clk = '1' AND clk'event);
        wr_index <= "110";
        wr_data <= X"00fd";
        WAIT UNTIL (clk = '1' AND clk'event);
        wr_index <= "111";
        wr_data <= X"fd00";
        WAIT UNTIL (clk = '1' AND clk'event);
        wr_enable <= '0';
        WAIT UNTIL (clk = '1' AND clk'event);
        rd_index2 <= "001";
        WAIT UNTIL (clk = '1' AND clk'event);
        rd_index1 <= "010";
        WAIT UNTIL (clk = '1' AND clk'event);
        rd_index2 <= "101";
        WAIT UNTIL (clk = '1' AND clk'event);
        rd_index1 <= "110";
        rd_index2 <= "111";
        WAIT;
    END PROCESS;
END behavioural;