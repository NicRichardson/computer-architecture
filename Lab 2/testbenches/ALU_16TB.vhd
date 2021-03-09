LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY test_alu IS END test_alu;

ARCHITECTURE behavioural OF test_alu IS
    COMPONENT alu_16 PORT (
        -- master control inputs
        rst : in std_logic;
        -- control input
        alu_mode : in std_logic_vector(2 downto 0);
        -- data inputs
        in1 : in std_logic_vector(15 downto 0);
        in2 : in std_logic_vector(15 downto 0);
        -- data output
        result : out std_logic_vector(15 downto 0);
        -- control output
        v_flag : out std_logic;
        z_flag : out std_logic;
        n_flag : out std_logic -- no;
        );
    END COMPONENT;
    SIGNAL rst, v_flag, z_flag, n_flag : STD_LOGIC;
    SIGNAL alu_mode : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL in1, in2, result : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    u0 : alu_16 PORT MAP(rst, alu_mode, in1, in2, result, v_flag, z_flag, n_flag);
    PROCESS BEGIN
        -- reset alu, zero inputs
        rst <= '1';
        alu_mode <= "000";
        in1 <= X"0000";
        in2 <= X"0000";
        wait for 10 us; 
        rst <= '0';
        wait for 10 us;
        ---- NOP ----
        -- result = 0x0000, v/n = 0, z = 1
        wait for 10 us;
        ---- ADDITION ----
        -- 1 + 1 = 2
        alu_mode <= "001";
        in1 <= X"0001";
        in2 <= X"0001";
        wait for 10 us;
        -- -1 + -1 = -2
        in1 <= X"FFFF";
        in2 <= X"FFFF";
        wait for 10 us;
        -- -1 + 2 = 1
        in1 <= X"FFFF";
        in2 <= X"0002";
        -- result = 1, z/n/v = 0
        wait for 10 us;
        -- -1 + 1 = 0
        in1 <= X"FFFF";
        in2 <= X"0001";
        -- result = 0, n/v = 0, z = 1
        wait for 10 us; 
        -- -2 + 1 = -1
        in1 <= X"FFFE"; -- -2
        in2 <= X"0001";
        wait for 10 us;
        -- max_int + 1 = overflow
        in1 <= X"7FFF";
        in2 <= X"0001";
        wait for 10 us;
        -- max_int + (-max_int) = 0
        in1 <= X"7FFF";
        in2 <= x"8001";
        wait for 10 us;
        ---- SUBTRACTION ----
        alu_mode <= "010";
        in1 <= X"0001";
        in2 <= X"0001";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"FFFF";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0002";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0001";
        wait for 10 us; 
        in1 <= X"FFFE"; 
        in2 <= X"0001";
        wait for 10 us;
        in1 <= X"7FFF";
        in2 <= X"0001";
        wait for 10 us;
        in1 <= X"7FFF";
        in2 <= x"8001";
        wait for 10 us;
        ---- MULTIPLICATION ----
        alu_mode <= "011";
        in1 <= X"0000";
        in2 <= X"0000";
        wait for 10 us;
        in1 <= X"0001";
        in2 <= X"0000";
        wait for 10 us;
        in1 <= X"0001";
        in2 <= X"0001";
        wait for 10 us;
        in1 <= X"1234";
        in2 <= X"0001";
        wait for 10 us;
        in1 <= X"0001";
        in2 <= X"FFFF";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"FFFF";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0000";
        wait for 10 us;
        in1 <= X"7FFF";
        in2 <= X"0002";
        wait for 10 us;
        in1 <= X"5555";
        in2 <= X"0002";
        wait for 10 us;
        in1 <= X"0002";
        in2 <= X"5555";
        wait for 10 us;
        ---- NAND ---- 
        alu_mode <= "100";
        in1 <= X"0000";
        in2 <= X"0000";
        wait for 10 us;
        in1 <= X"AAAA";
        in2 <= X"AAAA";
        wait for 10 us;
        in1 <= X"5555";
        in2 <= X"AAAA";
        wait for 10 us;
        in1 <= X"55AA";
        in2 <= X"AA55";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"FFFF";
        wait for 10 us;
        in1 <= X"FF00";
        in2 <= X"00FF";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0000";
        wait for 10 us;
        ----- SHL ----
        alu_mode <= "101";
        in1 <= X"FFFF";
        in2 <= X"0001";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0002";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0004";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0008";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"000F";
        wait for 10 us;
        ----- SHR ----
        alu_mode <= "110";
        in1 <= X"FFFF";
        in2 <= X"0001";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0002";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0004";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"0008";
        wait for 10 us;
        in1 <= X"FFFF";
        in2 <= X"000F";
        wait for 10 us;
        ---- TEST ----
        WAIT;
    END PROCESS;
END behavioural;