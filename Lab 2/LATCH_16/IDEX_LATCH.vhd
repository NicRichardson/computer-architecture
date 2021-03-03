
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY LATCH_16 IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_dr1      : in  std_logic_vector(16 downto 0);
        in_dr2      : in  std_logic_vector(16 downto 0);
        in_alumode  : in  std_logic_vector(2  downto 0);
        in_regwb    : in  std_logic;
        in_memwb    : in  std_logic;
        in_ra       : in  std_logic_vector(2  downto 0);
        -- matching output signals
        out_dr1     : out std_logic_vector(16 downto 0);
        out_dr2     : out std_logic_vector(16 downto 0);
        out_alumode : out std_logic_vector(2  downto 0);
        out_regwb   : out std_logic;
        out_memwb   : out std_logic;
        out_ra      : out std_logic_vector(2  downto 0)
        );        
END LATCH_16;

ARCHITECTURE behavioural OF LATCH_16 IS

    -- matching internals signals
    SIGNAL signal_dr1     : std_logic_vector(16 downto 0) := X"0000";
    SIGNAL signal_dr2     : std_logic_vector(16 downto 0) := X"0000";
    SIGNAL signal_alumode : std_logic_vector(2  downto 0) := "000";
    SIGNAL signal_regwb   : std_logic := '0';
    SIGNAL signal_memwb   : std_logic := '0';
    SIGNAL signal_ra      : std_logic_vector(2  downto 0) := "000";
    BEGIN
    --write operation 
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            if (rst = '1') THEN
                -- rst, set all internal latch variables to zero
                signal_dr1     <= X"0000";
                signal_dr2     <= X"0000";
                signal_alumode <= "000";
                signal_regwb   <= '0';
                signal_memwb   <= '0';
                signal_ra      <= "000";
            else
                -- on raising edge, input data and store
                signal_dr1     <= in_dr1;
                signal_dr2     <= in_dr2;
                signal_alumode <= in_alumode;
                signal_regwb   <= in_regwb;
                signal_memwb   <= in_memwb;
                signal_ra      <= in_ra;
                END if;
        END if;
    END PROCESS;
    -- async, output all internally stored values
    out_dr1     <= signal_dr1;
    out_dr12    <= signal_dr2;
    out_alumode <= signal_alumode;
    out_regwb   <= signal_regwb;
    out_memwb   <= signal_memwb;
    out_ra      <= signal_ra;

END behavioural;