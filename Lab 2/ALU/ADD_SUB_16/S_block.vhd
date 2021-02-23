library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity S_block is
    port (
        a : in  std_logic;
        b : in  std_logic;
        G : out std_logic;
        P : out std_logic
    );
end S_block;

architecture behavioural of S_block is

begin
    process(a, b)
    begin
        G <= b and a;
        P <= b xor a;
    end process;

end behavioural;