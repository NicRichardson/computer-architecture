
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
        v   : out std_logic
    );
    end component;
    signal add_sub_ci : std_logic := '0';
    signal add_sub_a  : std_logic_vector(15 downto 0) := (others => '0');
    signal add_sub_b  : std_logic_vector(15 downto 0) := (others => '0');
    signal out_buf    : std_logic_vector(15 downto 0) := (others => '0');
    signal v_buf      : std_logic := '0';
begin
    add_sub_16_0 : ADD_SUB_16 port map 
    (
        rst => rst,
        a   => add_sub_a,
        b   => add_sub_b,
        f   => out_buf,
        ci  => add_sub_ci,
        v   => v_buf
    );

    process(rst, alu_mode, in1, in2, out_buf, add_sub_b, add_sub_a, add_sub_ci, v_buf)
    begin
    if (rst = '1') then
        -- not sure if output needs to be set to zero
        -- RF8_16 does not do this
        z_flag <= '1';
        n_flag <= '0';
        v_buf <= '0';
        v_flag <= v_buf;
        add_sub_ci <= '0';
        add_sub_a <= (others => '0');
        add_sub_b <= (others => '0');
        out_buf <= (others => '0');
        result <= out_buf;
        -- set all internal values to default; zero
    else 
        case alu_mode(2 downto 0) is
            when "000" => -- NOP
                out_buf <= (others => '0');
                z_flag <= '1';
                n_flag <= '0';
                v_buf <= '0';
            when "001" => -- ADD
                add_sub_a  <= in1;
                add_sub_b  <= in2;
                add_sub_ci <= '0';
            when "010" => -- SUB
                add_sub_a  <= in1;
                add_sub_b  <= not in2;
                add_sub_ci <= '1';
            when "011" => -- MUL
                out_buf <= (others => '0');
                z_flag <= '1';
                n_flag <= '0';
                v_buf <= '0';
            when "100" => -- NAND
                out_buf <= in1 nand in2;
            when "101" => -- SHL
                out_buf <= (others => '0');
                z_flag <= '1';
                n_flag <= '0';
                v_buf <= '0';
            when "110" => -- SHR
                out_buf <= (others => '0');
                z_flag <= '1';
                n_flag <= '0';
                v_buf <= '0';
            when "111" => -- TEST
                if (in1 = X"0000") then -- zero value
                    z_flag <= '1';
                    n_flag <= '0';
                elsif (in1(15) = '1') then
                    z_flag <= '0';
                    n_flag <= '1';
                else 
                    z_flag <= '0';
                    n_flag <= '0';
                end if;
            when others =>
                out_buf <= (others => '0');
                z_flag <= '1';
                n_flag <= '0';
                v_buf <= '0';    
        end case;
        if (out_buf = X"0000") then
            z_flag <= '1';
        elsif (out_buf(15) = '1') then
            n_flag <= '1';
        end if;
        result <= out_buf;
        v_flag <= v_buf;
    end if;
    end process;
end behavioural ; -- behavioural