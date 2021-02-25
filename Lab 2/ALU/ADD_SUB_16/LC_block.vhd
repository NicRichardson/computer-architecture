library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity LC_block is
    port (
        LC_G  : in  std_logic;
        LC_Gp : in  std_logic;
        LC_P  : in  std_logic;
        LC_Pp : in  std_logic;
        LC_Gn : out std_logic;
        LC_Pn : out std_logic
    );
end LC_block;

architecture behavioural of LC_block is
    signal s : std_logic; 
begin
    process(LC_G, LC_Gp, LC_P, LC_Pp, s)
    begin
        s  <= LC_Gp and LC_P;
        LC_Pn <= LC_Pp and LC_P;
        LC_Gn <= LC_G or s;
    end process;

end behavioural;