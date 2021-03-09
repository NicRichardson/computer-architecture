
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
        in1 : in std_logic_vector(16 downto 0);
        in2 : in std_logic_vector(16 downto 0);
        -- data output
        result : out std_logic_vector(16 downto 0);
        -- control output
        z_flag : out std_logic;
        n_flag : out std_logic
    );
end ALU_16;

architecture behavioural of ALU_16 is
    -- shifter unit
    component BARREL_SHIFTER_16 is port (
        A        : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        B        : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        LEFT     : IN  STD_LOGIC; -- 1 is reversal
        Y        : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    end component BARREL_SHIFTER_16;
    SIGNAL BS_16_D_IN   : STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');
    SIGNAL BS_16_SHIFT  : STD_LOGIC_VECTOR (3 DOWNTO 0):= X"0";
    SIGNAL BS_16_LEFT   : STD_LOGIC := '0';
    SIGNAL BS_16_D_OUT  : STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');
    SIGNAL BS_16_D_V    : STD_LOGIC := '0';
    -- end shifter unit
    -- add/sub unit
    component ADD_SUB_16 is port (
        rst : in  std_logic;
        a   : in  std_logic_vector(15 downto 0);
        b   : in  std_logic_vector(15 downto 0);
        f   : out std_logic_vector(15 downto 0);
        ci  : in  std_logic;
        v   : out std_logic
    );
    end component ADD_SUB_16;
    signal add_sub_ci  : std_logic := '0';
    signal add_sub_a   : std_logic_vector(15 downto 0) := (others => '0');
    signal add_sub_b   : std_logic_vector(15 downto 0) := (others => '0');
    signal add_sub_out : std_logic_vector(15 downto 0) := (others => '0'); 
    signal add_sub_v   : std_logic := '0';
    -- end add/sub unit
    -- multiplication unit
    component MUL is port 
    (
        M      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        R      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        RESULT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        O_FLAG : OUT STD_LOGIC
    );
    end component MUL;
    signal mul_m : std_logic_vector(15 downto 0) := (others => '0');
    signal mul_r : std_logic_vector(15 downto 0) := (others => '0');
    signal mul_o : std_logic_vector(15 downto 0) := (others => '0');
    signal mul_v : std_logic := '0';
    -- end multiplication unit

    signal in1_wov    : std_logic_vector(15 downto 0) := (others => '0');
    signal in2_wov    : std_logic_vector(15 downto 0) := (others => '0');
    signal out_buf    : std_logic_vector(15 downto 0) := (others => '0');
    signal v_buf      : std_logic := '0';
begin
    BARREL_SHIFTER_16_0 : ENTITY work.BARREL_SHIFTER_16 PORT MAP
    (
        A        => BS_16_D_IN, 
        B        => BS_16_SHIFT, 
        LEFT     => BS_16_LEFT, 
        Y        => BS_16_D_OUT
    );
    
    add_sub_16_0 : ADD_SUB_16 port map 
    (
        rst => rst,
        a   => add_sub_a,
        b   => add_sub_b,
        f   => add_sub_out,
        ci  => add_sub_ci,
        v   => add_sub_v
    );

    mul_16_0 : MUL port map 
    (
        M      => mul_m,
        R      => mul_r,
        RESULT => mul_o,
        O_FLAG => mul_v
    );

    process(rst, alu_mode, in1, in2, out_buf, v_buf, 
            add_sub_b, add_sub_a, add_sub_ci, add_sub_out, add_sub_v, 
            BS_16_D_IN, BS_16_SHIFT, BS_16_LEFT, BS_16_D_OUT,
            mul_m, mul_r, mul_o, mul_v)
    begin
    if (rst = '1') then
        z_flag       <= '1';
        n_flag       <= '0';
        v_buf        <= '0';
        out_buf      <= (others => '0');

        add_sub_ci   <= '0';
        add_sub_a    <= (others => '0');
        add_sub_b    <= (others => '0');

        BS_16_D_IN   <= (others => '0');
        BS_16_SHIFT  <= (others => '0');
        BS_16_LEFT   <= '0';
        
        mul_m        <= (others => '0');
        mul_r        <= (others => '0');

        -- do not zero output signals from components!

        v_flag       <= v_buf;
        result       <= out_buf;
    else 
        in1_wov <= in1(15 downto 0);
        in2_wov <= in2(15 downto 0);
        case alu_mode(2 downto 0) is
            -- NOP
            when "000" => 
                -- NOP should not change system state

            -- ADD
            when "001" => 
                add_sub_a  <= in1_wov;
                add_sub_b  <= in2_wov;
                add_sub_ci <= '0';
                out_buf    <= add_sub_out;
                v_buf      <= add_sub_v;

            -- SUB
            when "010" => 
                add_sub_a  <= in1_wov;
                add_sub_b  <= not in2_wov;
                add_sub_ci <= '1';
                out_buf    <= add_sub_out;
                v_buf      <= add_sub_v;

            -- MUL
            when "011" => 
                mul_m   <= in1_wov;
                mul_r   <= in2_wov;
                out_buf <= mul_o;
                v_buf   <= mul_v;

            -- NAND
            when "100" => 
                out_buf <= in1_wov nand in2_wov;
                v_buf <= '0';

            -- SHL
            when "101" => 
                BS_16_D_IN   <= in1_wov;
                BS_16_SHIFT  <= in2_wov(3 downto 0); --supports upto 15 shifts
                BS_16_LEFT   <= '1';
                out_buf      <= BS_16_D_OUT;

            -- SHR
            when "110" => 
                BS_16_D_IN   <= in1_wov;
                BS_16_SHIFT  <= in2_wov(3 downto 0); --supports upto 15 shifts
                BS_16_LEFT   <= '0';
                out_buf      <= BS_16_D_OUT;

            -- TEST
            when "111" => 
                if (in1 = X"0000") then -- zero value
                    z_flag <= '1';
                    n_flag <= '0';
                    v_buf  <= '0';
                    
                elsif (in1(15) = '1') then
                    z_flag <= '0';
                    n_flag <= '1';
                    v_buf  <= '0';
                else 
                    z_flag <= '0';
                    n_flag <= '0';
                    v_buf  <= in1(16);
                end if;

            -- fallthrough
            when others =>
                out_buf <= (others => '0');
                z_flag  <= '1';
                n_flag  <= '0';
                v_buf   <= '0';  
        end case;

        -- check flags
        -- do not check if on test command
        -- do not update flags on NOP
        if (alu_mode /= "111" and alu_mode /= "000") then
            if (out_buf = X"0000") then
                z_flag <= '1';
                n_flag <= '0';
            elsif (out_buf(15) = '1') then
                n_flag <= '1';
                z_flag <= '0';
            end if;
        end if;

        -- move buffered outputs to output
        result <= v_buf & out_buf;
    end if;
    end process;
end behavioural ; -- behavioural