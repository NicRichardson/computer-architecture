
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU_16 is
    port(
        rst     : in std_logic;
        opcode  : in std_logic_vector(6 downto 0);
        alumode : out std_logic_vector(2 downto 0);
        regwb   : out std_logic;
        memwb   : out std_logic
    );
end ALU_16;

architecture behavioural of ALU_16 is

begin
    process(rst, opcode)
    begin
    if (rst = '1') then
        alumode <= "000";
        regwb   <= '0';
        memwb   <= '0';
    else 
        case opcode(6 downto 0) is
            when "0000000" => 
                alumode <= "000";
                regwb <= '0';
            when "0000001" => 
                alumode <= "001";
                regwb <= '1';
            when "0000010" => 
                alumode <= "010";
                regwb <= '1';
            when "0000011" => 
                alumode <= "011";
                regwb <= '1';
            when "0000100" => 
                alumode <= "100";
                regwb <= '1';
            when "0000101" => 
                alumode <= "101";
                regwb <= '1';
            when "0000110" => 
                alumode <= "110";
                regwb <= '1';
            when "0000111" => 
                alumode <= "111";
                regwb <= '1';
            when others    => 
                alumode <= "000";
                regwb <= '0';
                -- B1 and L1 format insturctions
                -- will also have regwb <= 0
        end case;
        -- not sure if other opcodes require the ALU for operation
        -- some of the branch ones will
        -- but for not it's fine since artimethic is the only one being tested
        -- in that case, memweb should always be 0
        -- and regwb will have to be determined
        memwb <= '0';      
    end if;
    end process;
end behavioural ; -- behavioural