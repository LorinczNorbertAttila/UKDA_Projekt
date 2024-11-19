----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2024 10:17:55 AM
-- Design Name: 
-- Module Name: bram_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bram_controller is
    Port ( address : in STD_LOGIC_VECTOR (12 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_data : out STD_LOGIC_VECTOR (31 downto 0));
end bram_controller;

architecture Behavioral of bram_controller is

type state_type is (INIT, RDY, IDLE, ADDRESSING, READING, OUTPUT);
signal current_state, next_state : state_type;

begin

process(clk)
begin
    if rising_edge(clk) then
        current_state <= next_state;
    end if;
end process;

process(current_state, sample_tick, reset)
begin
    case current_state is
        when RDY =>
            if reset = '0' then
                next_state <= INIT;
            else
                next_state <= RDY;
            end if;
        when INIT =>
            if sample_tick = '1' then
                next_state <= ADDRESSING;
            else
                next_state <= INIT;
            end if;
        when IDLE =>
            if sample_tick = '1' then
                next_state <= ADDRESSING;
            else
                next_state <= IDLE;
            end if;
        when ADDRESSING =>
            next_state <= READING;
        when READING =>
            next_state <= OUTPUT;
        when OUTPUT =>
            next_state <= IDLE;
        when others =>
            next_state <= INIT;
    end case;
end process;

end Behavioral;
