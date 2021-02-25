library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity S_block is
    port (
        S_a : in  std_logic;
        S_b : in  std_logic;
        S_G : out std_logic;
        S_P : out std_logic
    );
end S_block;

architecture behavioural of S_block is

begin
    process(S_a, S_b)
    begin
        S_G <= S_b and S_a;
        S_P <= S_b xor S_a;
    end process;

end behavioural;