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

    -- Állapotok típusa
    type state_type is (INIT, RDY, IDLE, PLAYING, STOPPING, RESETTING);
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
    process(current_state, play, stop)
    begin
        --Kezd? értékek
        enable <= '0';
        reset <= '0';
            
        case current_state is
            when INIT =>
                reset <= '1'; 
                next_state <= RDY;
    
            when RDY =>
                if play = '1' then
                    next_state <= PLAYING;
                else
                    next_state <= IDLE;
                end if;
    
            when IDLE =>
                if play = '1' then
                    next_state <= PLAYING;
                elsif stop = '1' then
                    next_state <= RESETTING;
                else
                    next_state <= IDLE;
                end if;
    
            when PLAYING =>
                enable <= '1';
                if stop = '1' then
                    next_state <= STOPPING;
                else
                    next_state <= PLAYING;
                end if;
    
            when STOPPING =>
                enable <= '0';
                next_state <= RESETTING;
    
            when RESETTING =>
                reset <= '1';
                next_state <= RDY;
    
            when others =>
                next_state <= INIT;
    
        end case;
    end process;




end Behavioral;
