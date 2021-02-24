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
        rst <= '0';
        wait for 10 us; 
        rst <= '0';
        wait for 10 us;
        ---- NOP ----
        -- result = 0x0000, v/n = 0, z = 1
        assert(result = X"0000");
        assert(z_flag = '1');
        assert(n_flag = '0');
        assert(v_flag = '0');
        wait for 10 us;
        ---- ADDITION ----
        -- 1 + 1 = 2
        alu_mode <= "001";
        in1 <= X"0001";
        in2 <= X"0001";
        -- result = 0x0002, z/n/v = 0
        assert(result = X"0002");
        assert(z_flag = '0');
        assert(n_flag = '0');
        assert(v_flag = '0');
        wait for 10 us;
        -- -1 + -1 = -2
        in1 <= X"FFFF";
        in2 <= X"FFFF";
        -- result = 0xFFFE, z/v = 0, n = 1
        assert(result = X"FFFE");
        assert(z_flag = '0');
        assert(n_flag = '1');
        assert(v_flag = '0');
        wait for 10 us;
        -- -1 + 2 = 1
        in2 <= X"0002";
        -- result = 1, z/n/v = 0
        assert(result = X"0001");
        assert(z_flag = '0');
        assert(n_flag = '0');
        assert(v_flag = '0');
        wait for 10 us;
        -- -1 + 1 = 0
        in2 <= X"0001";
        -- result = 0, n/v = 0, z = 1
        assert(result = X"0000");
        assert(z_flag = '1');
        assert(n_flag = '0');
        assert(v_flag = '0');
        wait for 10 us; 
        -- -2 + 1 = -1
        in1 <= X"FFFE"; -- -2
        -- result = 0xFFFF (-1), z/v = 0, n = 1
        assert(result = X"FFFF");
        assert(z_flag = '0');
        assert(n_flag = '1');
        assert(v_flag = '0');
        wait for 10 us;
        -- max_int + 1 = overflow
        in1 <= X"7FFF";
        -- result = 0x8000, z = 0, n/v = 1
        assert(result = X"8000");
        assert(z_flag = '0');
        assert(n_flag = '1');
        assert(v_flag = '1');
        wait for 10 us;
        -- max_int + (-max_int) = 0
        in2 <= x"8001";
        -- result = 0, n/v = 0, z = 1
        assert(result = X"0000");
        assert(z_flag = '1');
        assert(n_flag = '0');
        assert(v_flag = '0');
        wait for 10 us;
        ---- SUBTRACTION ----
        alu_mode <= "010";

        ---- MULTIPLICATION ----
        --alu_mode <= "011";

        ---- NAND ---- 
        alu_mode <= "100";

        WAIT;
    END PROCESS;
END behavioural;