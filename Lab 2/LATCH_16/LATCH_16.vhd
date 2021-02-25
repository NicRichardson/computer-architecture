
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY LATCH_16 IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_a : in std_logic_vector(15 downto 0);
        -- matching output signals
        out_a : out std_logic_vector(15 downto 0)
        );        
END LATCH_16;

ARCHITECTURE behavioural OF LATCH_16 IS

    -- matching internals signals
    SIGNAL signal_a : std_logic_vector(15 downto 0) := X"0000";
BEGIN
    --write operation 
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            if (rst = '1') THEN
                -- rst, set all internal latch variables to zero
                signal_a <= X"0000";
            else
                -- on raising edge, input data and store
                signal_a <= in_a;
            END if;
        END if;
    END PROCESS;
    -- async, output all internally stored values
    out_a <= signal_a;

END behavioural;