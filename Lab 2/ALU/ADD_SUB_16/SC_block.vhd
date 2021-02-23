library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SC_block is
    port (
        Gn : in  std_logic;
        Pn : in  std_logic;
        L  : in  std_logic;
        C  : out std_logic
    );
end SC_block;

architecture behavioural of SC_block is
    signal s : std_logic;
begin
    process(Gn, Pn, L)
    begin
        s <= L and Pn;
        C <= Gn or S;
    end process;

end behavioural;