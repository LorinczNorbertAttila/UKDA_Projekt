----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2024 10:20:38 AM
-- Design Name: 
-- Module Name: audio_output - Behavioral
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

entity audio_output is
    Port ( sample_data : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           audio_out : out STD_LOGIC_VECTOR (31 downto 0));
end audio_output;

architecture Behavioral of audio_output is

    -- Állapotok típusa
    type state_type is (INIT, RDY, IDLE, PROCESSING, OUTPUT);
    signal current_state, next_state : state_type;

begin
    
    -- Állapotregiszter frissítése
    process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    -- Állapotgép m?ködése
    process(current_state)
    begin
        case current_state is
           WHEN RDY =>
            next_state <= INIT;
           WHEN INIT =>
            next_state <= IDLE;
           WHEN IDLE => 
            next_state <= PROCESSING;
           WHEN PROCESSING => 
            next_state <= OUTPUT;
         end case;
    end process;


end Behavioral;
