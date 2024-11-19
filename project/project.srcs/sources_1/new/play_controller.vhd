----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2024 10:22:23 AM
-- Design Name: 
-- Module Name: play_controller - Behavioral
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

entity play_controller is
    Port ( play : in STD_LOGIC;
           stop : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC;
           reset : out STD_LOGIC);
end play_controller;

architecture Behavioral of play_controller is

type state_type is (INIT, RDY, IDLE, PLAYING, STOPING, RESETING);
signal current_state, next_state : state_type;

begin

process(clk)
begin
    if rising_edge(clk) then
        current_state <= next_state;
    end if;
end process;




end Behavioral;
