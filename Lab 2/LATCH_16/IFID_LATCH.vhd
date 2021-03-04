
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY IFID_LATCH IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_opcode  : in  std_logic_vector(6 downto 0);
        in_ra      : in  std_logic_vector(2 downto 0);
        in_rb      : in  std_logic_vector(2 downto 0);
        in_rc      : in  std_logic_vector(2 downto 0);
        -- matching output signals
        out_opcode : out std_logic_vector(6 downto 0);
        out_ra     : out std_logic_vector(2 downto 0);
        out_rb     : out std_logic_vector(2 downto 0);
        out_rc     : out std_logic_vector(2 downto 0)
        );        
END IFID_LATCH;

ARCHITECTURE behavioural OF IFID_LATCH IS

    -- matching internals signals
    SIGNAL signal_opcode : std_logic_vector(6 downto 0) := "0000000";
    SIGNAL signal_ra     : std_logic_vector(2 downto 0) := "000";
    SIGNAL signal_rb     : std_logic_vector(2 downto 0) := "000";
    SIGNAL signal_rc     : std_logic_vector(2 downto 0) := "000";
BEGIN
    --write operation 
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            if (rst = '1') THEN
                -- rst, set all internal latch variables to zero
                signal_opcode <= "0000000";
                signal_ra     <= "000";
                signal_rb     <= "000";
                signal_rc     <= "000";
            else
                -- on raising edge, input data and store
                signal_opcode <= in_opcode;
                signal_ra     <= in_ra;
                signal_rb     <= in_rb;
                signal_rc     <= in_rc;
            END if;
        END if;
    END PROCESS;
    -- async, output all internally stored values
    out_opcode <= signal_opcode;
    out_ra <= signal_ra;
    out_rb <= signal_rb;
    out_rc <= signal_rc;

END behavioural;