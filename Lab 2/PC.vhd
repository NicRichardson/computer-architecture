
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

ENTITY PC_16 IS
    PORT (
        clk  : in  std_logic;
        con  : in  std_logic_vector(1 downto 0);
        pc_i : in  std_logic_vector(15 downto 0);
        pc_o : out std_logic_vector(15 downto 0)
        );
END PC_16;

ARCHITECTURE behavioural OF PC_16 IS
    SIGNAL pc : std_logic_vector(15 downto 0) := X"0000";
BEGIN
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            case con is
                -- increment PC
                when "00" =>
                pc <= std_logic_vector(unsigned(pc) + 1);
                -- do not increment PC
                when "01" =>
                    -- no action required
                -- Set PC to external value (for jumps)
                when "10" =>
                    pc <= pc_i;
                -- reset, set PC to program start
                when "11" =>
                    pc <= X"0000";
                when others =>
            end case;
        END if;
    END PROCESS; 

    pc_o <= pc;

END behavioural;