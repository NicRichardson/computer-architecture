
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU_16 is
    port(
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
end ALU_16;

architecture behavioural of ALU_16 is
    component ADD_SUB_16 is port (
        rst : in  std_logic;
        a   : in  std_logic_vector(15 downto 0);
        b   : in  std_logic_vector(15 downto 0);
        f   : out std_logic_vector(15 downto 0);
        ci  : in  std_logic;
        co  : out std_logic
    );
    end component;
    signal add_sub_ci std_logic;
    signal add_sub_co std_logic;
    signal add_sub_a  std_logic;
    signal add_sub_b  std_logic;
begin
    add_sub_16 : ADD_SUB_16 port map 
    (
        rst => rst,
        a   => add_sub_a,
        b   => add_sub_b,
        f   => result,
        ci  => add_sub_ci,
        co  => add_sub_co
    );

    process(rst, alu_mode, in1, in2)
    begin
    if (rst = '1') then
        -- not sure if output needs to be set to zero
        -- RF8_16 does not do this
        result <= (others => '0');
        z_flag <= '1';
        n_flag <= '0';
        v_flag <= '0';
        add_sub_ci <= '0';
        add_sub_co <= '0';
        add_sub_a <= '0';
        add_sub_b <= '0';
        -- set all internal values to default; zero
    else 
        case alu_mode(2 downto 0) is
            when "000" => -- NOP
                result <= (others => '0');
                z_flag <= '1';
                n_flag <= '0';
                v_flag <= '0';
            when "001" => -- ADD
                add_sub_a  <= in1;
                add_sub_b  <= in2;
                add_sub_ci <= '0';
                v_flag <= ((in1(15) xnor in2(15)) = result(15));
            when "010" => -- SUB
                add_sub_a  <= in1;
                add_sub_b  <= not in2;
                add_sub_ci <= '1';
                v_flag <= ((in1(15) xnor in2(15)) = result(15));
            --when "011" => -- MUL
                
            when "100" => -- NAND
                result <= in1 nand in2;
            --when "101" => -- SHL

            --when "110" => -- SHR
                
            when "111" => -- TEST
                if (in1 = X"0000") then -- zero value
                    z_flag <= '1';
                    n_flag <= '0';
                elsif (in1(to_integer(unsigned(15))) = '1') then
                    z_flag <= '0';
                    n_flag <= '1';
                else 
                    z_flag <= '0';
                    n_flag <= '0';
                end if;
        end case;
        if (result = X"0000") then
            z_flag <= '1';
        elsif (result(to_integer(unsigned(15))) = '1') then
            n_flag <= '1';
        end if;
    end if;
    end process;
end behavioural ; -- behavioural