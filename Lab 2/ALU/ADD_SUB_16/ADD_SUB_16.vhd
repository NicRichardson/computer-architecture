library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ADD_SUB_16 is
    port (
        rst : in  std_logic;
        a   : in  std_logic_vector(15 downto 0);
        b   : in  std_logic_vector(15 downto 0);
        f   : out std_logic_vector(15 downto 0);
        ci  : in  std_logic;
        v  : out std_logic
    );
end ADD_SUB_16;

architecture behavioural of ADD_SUB_16 is
    component S_block is port (
        S_a : in  std_logic;
        S_b : in  std_logic;
        S_G : out std_logic;
        S_P : out std_logic
    );
    end component;
    component LC_block is port (
        LC_G  : in  std_logic;
        LC_Gp : in  std_logic;
        LC_P  : in  std_logic;
        LC_Pp : in  std_logic;
        LC_Gn : out std_logic;
        LC_Pn : out std_logic
    );
    end component;
    component SC_block is port (
        SC_Gn : in  std_logic;
        SC_Pn : in  std_logic;
        SC_L  : in  std_logic;
        SC_C  : out std_logic
    );
    end component;

    -- layer 0
    signal S_G_vec   : std_logic_vector(15 downto 0);
    signal S_P_vec   : std_logic_vector(15 downto 0);

    --layer 1
    signal SC_C_1_0   : std_logic;
    signal LC_Gn_vec1 : std_logic_vector(14 downto 0);
    signal LC_Pn_vec1 : std_logic_vector(14 downto 0);

    -- layer 2
    signal SC_C_2_1   : std_logic;
    signal SC_C_2_2   : std_logic;
    signal LC_Gn_vec2 : std_logic_vector(12 downto 0);
    signal LC_Pn_vec2 : std_logic_vector(12 downto 0);

    -- layer 3
    signal SC_C_3_3   : std_logic;
    signal SC_C_3_4   : std_logic;
    signal SC_C_3_5   : std_logic;
    signal SC_C_3_6   : std_logic;
    signal LC_Gn_vec3 : std_logic_vector(8 downto 0);
    signal LC_Pn_vec3 : std_logic_vector(8 downto 0);

    -- layer 4
    signal SC_C_4_7  : std_logic;
    signal SC_C_4_8  : std_logic;
    signal SC_C_4_9  : std_logic;
    signal SC_C_4_10 : std_logic;
    signal SC_C_4_11 : std_logic;
    signal SC_C_4_12 : std_logic;
    signal SC_C_4_13 : std_logic;
    signal SC_C_4_14 : std_logic;
    signal LC_Gn_4_1 : std_logic;
    signal LC_Pn_4_1 : std_logic;


begin
    -- layer 0
    S_gen : for i in 0 to 15 generate
        S_BLOCK0 : S_block port map 
        (
            S_a => a(i),
            S_b => b(i),
            S_G => S_G_vec(i),
            S_P => S_P_vec(i)
        );
    end generate S_gen;

    -- layer 1
    SC_1_1 : SC_block port map
    (
        SC_Pn => S_P_vec(0),
        SC_Gn => S_G_vec(0),
        SC_L  => ci,
        SC_C  => SC_C_1_0
    );
    LC_gen1 : for i in 0 to 14 generate
        LC_BLOCK1 : LC_block port map
        (
            LC_G  => S_G_vec(i+1),
            LC_P  => S_P_vec(i+1),
            LC_Gp => S_G_vec(i),
            LC_Pp => S_P_vec(i),
            LC_Gn => LC_Gn_vec1(i),
            LC_Pn => LC_Pn_vec1(i)
        );
    end generate LC_gen1;
    
    -- layer 2
    SC_gen2_1 : SC_block port map
    (
        SC_Pn => LC_Pn_vec1(0),
        SC_Gn => LC_Gn_vec1(0),
        SC_L  => ci,
        SC_C  => SC_C_2_1
    );
    SC_gen2_2 : SC_block port map
    (
        SC_Pn => LC_Pn_vec1(1),
        SC_Gn => LC_Gn_vec1(1),
        SC_L  => SC_C_1_0,
        SC_C  => SC_C_2_2
    );
    LC_gen2 : for i in 0 to 12 generate
        LC_BLOCK2 : LC_block port map 
        (
            LC_G  => LC_Gn_vec1(i+2),
            LC_P  => LC_Pn_vec1(i+2),
            LC_Gp => LC_Gn_vec1(i+1),
            LC_Pp => LC_Pn_vec1(i+1),
            LC_Gn => LC_Gn_vec2(i),
            LC_Pn => LC_Pn_vec2(i)
        );
    end generate LC_gen2;

    -- layer 3
    SC_gen3_3 : SC_block port map
    (
        SC_Pn => LC_Pn_vec2(0),
        SC_Gn => LC_Gn_vec2(0),
        SC_L  => ci,
        SC_C  => SC_C_3_3
    );
    SC_gen3_4 : SC_block port map
    (
        SC_Pn => LC_Pn_vec2(1),
        SC_Gn => LC_Gn_vec2(1),
        SC_L  => SC_C_1_0,
        SC_C  => SC_C_3_4
    );
    SC_gen3_5 : SC_block port map
    (
        SC_Pn => LC_Pn_vec2(2),
        SC_Gn => LC_Gn_vec2(2),
        SC_L  => SC_C_2_1,
        SC_C  => SC_C_3_5
    );
    SC_gen3_6 : SC_block port map
    (
        SC_Pn => LC_Pn_vec2(3),
        SC_Gn => LC_Gn_vec2(3),
        SC_L  => SC_C_2_2,
        SC_C  => SC_C_3_6
    );
    LC_gen3 : for i in 0 to 8 generate
        LC_BLOCK3 : LC_block port map 
        (
            LC_G  => LC_Gn_vec2(i+4),
            LC_P  => LC_Pn_vec2(i+4),
            LC_Gp => LC_Gn_vec2(i+3),
            LC_Pp => LC_Pn_vec2(i+3),
            LC_Gn => LC_Gn_vec3(i),
            LC_Pn => LC_Pn_vec3(i)
        );
    end generate LC_gen3;

    -- layer 4
    SC_gen4_7 : SC_block port map
    (
        SC_Pn => LC_Pn_vec3(0),
        SC_Gn => LC_Gn_vec3(0),
        SC_L  => ci,
        SC_C  => SC_C_4_7
    );
    SC_gen4_8 : SC_block port map
    (
        SC_Pn => LC_Pn_vec3(1),
        SC_Gn => LC_Gn_vec3(1),
        SC_L  => SC_C_1_0,
        SC_C  => SC_C_4_8
    );
    SC_gen4_9 : SC_block port map
    (
        SC_Pn => LC_Pn_vec3(2),
        SC_Gn => LC_Gn_vec3(2),
        SC_L  => SC_C_2_1,
        SC_C  => SC_C_4_9
    );
    SC_gen4_10 : SC_block port map
    (
        SC_Pn => LC_Pn_vec3(3),
        SC_Gn => LC_Gn_vec3(3),
        SC_L  => SC_C_2_2,
        SC_C  => SC_C_4_10
    );
    SC_gen4_11 : SC_block port map
    (
        SC_Pn => LC_Pn_vec3(4),
        SC_Gn => LC_Gn_vec3(4),
        SC_L  => SC_C_3_3,
        SC_C  => SC_C_4_11
    );
    SC_gen4_12 : SC_block port map
    (
        SC_Pn => LC_Pn_vec3(5),
        SC_Gn => LC_Gn_vec3(5),
        SC_L  => SC_C_3_4,
        SC_C  => SC_C_4_12
    );
    SC_gen4_13 : SC_block port map
    (
        SC_Pn => LC_Pn_vec3(6),
        SC_Gn => LC_Gn_vec3(6),
        SC_L  => SC_C_3_5,
        SC_C  => SC_C_4_13
    );
    SC_gen4_14 : SC_block port map
    (
        SC_Pn => LC_Pn_vec3(7),
        SC_Gn => LC_Gn_vec3(7),
        SC_L  => SC_C_3_6,
        SC_C  => SC_C_4_14
    );
    LC_gen4 : LC_block port map 
    (
        LC_G  => LC_Gn_vec3(8),
        LC_P  => LC_Pn_vec3(8),
        LC_Gp => LC_Gn_vec3(0),
        LC_Pp => LC_Pn_vec3(0),
        LC_Gn => LC_Gn_4_1,
        LC_Pn => LC_Pn_4_1
    );

    process(rst, a, b, ci,
            SC_C_1_0, 
            SC_C_2_1, 
            SC_C_2_2, 
            SC_C_3_3, 
            SC_C_3_4, 
            SC_C_3_5, 
            SC_C_3_6, 
            SC_C_4_7, 
            SC_C_4_8, 
            SC_C_4_9, 
            SC_C_4_10, 
            SC_C_4_11, 
            SC_C_4_12, 
            SC_C_4_13, 
            SC_C_4_14, 
            LC_Gn_4_1,
            LC_Pn_4_1,
            S_P_vec
            )
    begin
        if (rst = '1') then
            f <= (others => '0');
            v <= '0';
        else
            f(0)  <= S_P_vec(0)  xor ci;
            f(1)  <= S_P_Vec(1)  xor SC_C_1_0;
            f(2)  <= S_P_vec(2)  xor SC_C_2_1;
            f(3)  <= S_P_vec(3)  xor SC_C_2_2;
            f(4)  <= S_P_vec(4)  xor SC_C_3_3;
            f(5)  <= S_P_vec(5)  xor SC_C_3_4;
            f(6)  <= S_P_vec(6)  xor SC_C_3_5;
            f(7)  <= S_P_vec(7)  xor SC_C_3_6;
            f(8)  <= S_P_vec(8)  xor SC_C_4_7;
            f(9)  <= S_P_vec(9)  xor SC_C_4_8;
            f(10) <= S_P_vec(10) xor SC_C_4_9;
            f(11) <= S_P_vec(11) xor SC_C_4_10;
            f(12) <= S_P_vec(12) xor SC_C_4_11;
            f(13) <= S_P_vec(13) xor SC_C_4_12;
            f(14) <= S_P_vec(14) xor SC_C_4_13;
            f(15) <= S_P_vec(15) xor SC_C_4_14;
            v <= SC_C_4_14 xor (LC_Gn_4_1 or (LC_Pn_4_1 and ci));
        end if;
    end process;

end behavioural;