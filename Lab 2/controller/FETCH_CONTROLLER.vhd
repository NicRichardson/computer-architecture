
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FETCH_CONTROLLER is
    port(
        rst_exe   : in  std_logic;
        rst_load  : in  std_logic;
        stall     : in  std_logic;
        pc_adr_i  : in  std_logic_vector(15 downto 0);
        pc_adr_o  : out std_logic_vector(15 downto 0);
        pc_con    : out std_logic_vector( 1 downto 0);
        -- enables read for the memory unit
        rom_rd_en : out std_logic;
        ram_rd_en : out std_logic;
        -- address to be sent to memory unit
        rom_adr   : out std_logic_vector(15 downto 0);
        ram_adr   : out std_logic_vector(15 downto 0);
        -- memory type: 0 - ROM, 1 - RAM
        mem_sel   : out std_logic
    );
end FETCH_CONTROLLER;

architecture behavioural of FETCH_CONTROLLER is

begin
    process(rst_exe, rst_load, stall, pc_adr_i)
    begin
    if (rst_exe = '1') then
        pc_con    <= "11";
        pc_adr_o  <= X"0000";
        rom_rd_en <= '0';
        ram_rd_en <= '0';
        rom_adr   <= X"0000";
        ram_adr   <= X"0000";
        mem_sel   <= '0';
    elsif (rst_load = '1') then
        pc_con    <= "10";
        pc_adr_o  <= X"0002";
        rom_rd_en <= '0';
        ram_rd_en <= '0';
        rom_adr   <= X"0000";
        ram_adr   <= X"0000";
        mem_sel   <= '0';
    elsif (stall = '1') then
        -- do branch stall
        PC <= "01";
    else
        if    (unsigned(pc_adr_i) < unsigned(X"0400")) then
            -- ROM
            pc_con    <= "00";
            pc_adr_o  <= X"0000";
            rom_rd_en <= '1';
            ram_rd_en <= '0';
            rom_adr   <= '0' & pc_adr_i(15 downto 1);
            ram_adr   <= X"0000";
            mem_sel   <= '0';
        elsif (unsigned(pc_adr_i) >= unsigned(X"0400") 
              or unsigned(pc_adr_i) < unsigned(X"0800")) then
            -- RAM
            pc_con    <= "00";
            pc_adr_o  <= X"0000";
            rom_rd_en <= '0';
            ram_rd_en <= '1';
            rom_adr   <= X"0000";
            ram_adr   <= '0' & pc_adr_i(15 downto 1);
            mem_sel   <= '1';
        else
        -- memoery addresses are out of range, reset system
            pc_con    <= "11";
            pc_adr_o  <= X"0000";
            rom_rd_en <= '0';
            ram_rd_en <= '0';
            rom_adr   <= X"0000";
            ram_adr   <= X"0000";
            mem_sel   <= '0';
        end if;
    end if;
    end process;
end behavioural ; -- behavioural