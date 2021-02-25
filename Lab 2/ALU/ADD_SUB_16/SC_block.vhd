library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SC_block is
    port (
        SC_Gn : in  std_logic;
        SC_Pn : in  std_logic;
        SC_L  : in  std_logic;
        SC_C  : out std_logic
    );
end SC_block;

architecture behavioural of SC_block is
    signal s : std_logic;
begin
    process(SC_Gn, SC_Pn, SC_L, s)
    begin
        s <= SC_L and SC_Pn;
        SC_C <= SC_Gn or s;
    end process;

end behavioural;