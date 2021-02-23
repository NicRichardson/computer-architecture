LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY test_add_sub IS END test_add_sub;

ARCHITECTURE behavioural OF test_add_sub IS
    COMPONENT ADD_SUB_16 PORT 
    (
        rst : in  std_logic;
        a   : in  std_logic_vector(15 downto 0);
        b   : in  std_logic_vector(15 downto 0);
        f   : out std_logic_vector(15 downto 0);
        ci  : in  std_logic;
        co  : out std_logic
    );
    END COMPONENT;
    signal rst, ci , co : std_logic;
    signal a, b, f : std_logic_vector(15 downto 0);
BEGIN
    u0 : ADD_SUB_16 PORT MAP(rst, a, b, f, ci, co);
    PROCESS BEGIN
        rst <= '1';
        a <= X"0000";
        b <= X"0000";
        ci <= '0';
        wait for 10 us;
        assert (f = X"0000") report "rst, f";
        assert    (co = '0') report "rst, co";
        
        rst = '0';
        wait for 10 us;

        a <= X"0001";
        b <= X"0001";
        wait for 10 us;
        assert (f = X"0002") report "Ef:  1+1=2";
        assert    (co = '0') report "Eco: 1+1=2";

        a <= X"FFFF";
        b <= X"FFFF";
        wait for 10 us;
        assert (f = X"FFFE") report "Ef:  -1+-1=-2";
        assert    (co = '1') report "Eco: -1+-1=-2";

        a <= X"5555";
        b <= X"AAAA";
        wait for 10 us;
        assert (f = X"FFFF") report "Ef:  21845+-21846=-1";
        assert    (co = '0') report "Eco: 21845+-21846=-1";

        b <= X"5555";
        a <= X"AAAA";
        wait for 10 us;
        assert (f = X"FFFF") report "Ef:  -21846+21845=-1";
        assert    (co = '0') report "Eco: -21846+21845=-1";

        wait;
    END PROCESS;
END behavioural;