library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity LC_block is
    port (
        G  : in  std_logic;
        Gp : in  std_logic;
        P  : in  std_logic;
        Pp : in  std_logic;
        Gn : out std_logic;
        Pn : out std_logic
    );
end LC_block;

architecture behavioural of LC_block is
    signal s : std_logic; 
begin
    process(G, Gp, P, Pp)
    begin
        s  <= Gp and P;
        Pn <= Pp and P;
        Gn <= G or s;
    end process;

end behavioural;