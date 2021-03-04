
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

ENTITY V_REG IS
    PORT (
        rst  : IN    STD_LOGIC;
        rw   : in    std_logic;
        data : inout std_logic;
        adr  : in    std_logic_vector(2 downto 0)
        );        
END V_REG;

ARCHITECTURE behavioural OF V_REG IS

    -- matching internals signals
    SIGNAL v_reg_s : std_logic_vector(7 downto 0) := X"00";
BEGIN
    --write operation 
    PROCESS(rst, rw, data, adr)
    BEGIN
        if (rst = '1') THEN
            -- rst, zero out register
            v_reg_s <= X"00";
        else
            if (rw = '0') then
                data <= v_reg_s(to_integer(unsigned(adr));
            else
                v_reg_s(to_integer(unsigned(adr)) <= data;
            end if;
        END if;
    END PROCESS

END behavioural;