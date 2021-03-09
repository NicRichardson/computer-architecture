
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DECODE_CONTROLLER is
    port(
        rst     : in  std_logic;
        opcode  : in  std_logic_vector( 6 downto 0);
        alumode : out std_logic_vector( 2 downto 0);
        ra      : in  std_logic_vector( 2 downto 0);
        rb      : in  std_logic_vector( 2 downto 0);
        rc      : in  std_logic_vector( 2 downto 0);
        rdst    : out std_logic_vector( 2 downto 0);
        r1a     : out std_logic_vector( 2 downto 0);
        r2a     : out std_logic_vector( 2 downto 0);
        altd2   : out std_logic_vector(16 downto 0);
        r2den   : out std_logic;
        regwb   : out std_logic;
        memwb   : out std_logic
    );
end DECODE_CONTROLLER;

architecture behavioural of DECODE_CONTROLLER is
    signal format : std_logic_vector(2 downto 0) := "000";
begin
    process(rst, opcode, ra, rb, rc)
    begin
    if (rst = '1') then
        alumode <= "000";
        regwb   <= '0';
        memwb   <= '0';
        rdst    <= ra;
        r1a     <= "000";
        r2a     <= "000";
        r2den   <= '0';
        altd2   <= (others => '0');
    else 
        case opcode(6 downto 0) is
            when "0000000" => 
                alumode <= "000";
                format  <= "000";

            -- ADD
            when "0000001" => 
                alumode <= "001";
                format  <= "001";

            -- SUB
            when "0000010" => 
                alumode <= "010";
                format  <= "001";

            -- MUL
            when "0000011" => 
                alumode <= "011";  
                format  <= "001";

            -- NAND
            when "0000100" => 
                alumode <= "100";
                format  <= "001";

            -- SHL
            when "0000101" => 
                alumode <= "101";
                format  <= "010";

            -- SHR
            when "0000110" => 
                alumode <= "110";
                format  <= "010"; 

            -- TEST
            when "0000111" => 
                alumode <= "111";
                format  <= "011"; 

            -- OUT
            when "0100000" => 
                alumode <= "000";
                format  <= "011"; 
                regwb <= '0';
                memwb <= '1'; 

            -- IN
            when "0100001" => 
                alumode <= "000";
                format  <= "011"; 
                regwb <= '1';
                memwb <= '0'; 

            -- not an ALU operation
            when others    => 
                alumode <= "000";
                regwb <= '0';
                memwb <= '0';
                -- B1 and L1 format insturctions
                -- will also have regwb <= 0

        end case;
        -- not sure if other opcodes require the ALU for operation
        -- some of the branch ones will
        -- but for not it's fine since artimethic is the only one being tested  

        -- perform action based on format
        case format(2 downto 0) is
            -- Format A0
            when "000" =>
                regwb   <= '0';
                memwb   <= '0'; 
                rdst    <= ra;
                r1a     <= "000";
                r2a     <= "000";
                r2den   <= '1';
                altd2   <= (others => '0');

            -- Format A1
            when "001" =>
                regwb <= '1';
                memwb <= '0'; 
                rdst    <= ra;
                r1a     <= rb;
                r2a     <= rc;
                r2den   <= '1';
                altd2   <= (others => '0');

            -- Format A2
            when "010" =>
                regwb <= '1';
                memwb <= '0';
                rdst    <= ra;
                r1a     <= ra;
                r2den   <= '0';
                altd2   <= '0' & X"000" & rb(0) & rc(2 downto 0);

            -- Format A3
            when "011" => 
                rdst    <= ra;
                r1a     <= ra;
                r2a     <= "000"; 
                r2den   <= '1';
                altd2   <= (others => '0');

            when others =>
                -- this is where the other formats will be tested first

        end case;
        
    end if;
    end process;
end behavioural ; -- behavioural