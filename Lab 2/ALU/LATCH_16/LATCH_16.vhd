
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY LATCH_16 IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_a : in std_logic;
        -- matching output signals
        out_a : out std_logic;
        
END LATCH_16;

ARCHITECTURE behavioural OF LATCH_16 IS

    -- matching internals signals
    SIGNAL signal_a : std_logic;
BEGIN
    --write operation 
    PROCESS(clk)
    BEGIN
        if (clk = '0' AND clk'event) THEN
            if (rst = '1') THEN
                -- rst, set all internal latch variables to zero
                signal_a <= '0';
            else
                -- on raising edge, output all internally stored values
                out_a <= signal_a;
            END if;
        END if;
    END PROCESS;
    -- async, input data and store
    signal_a <= in_a;

END behavioural;