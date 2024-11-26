----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2024 11:12:45 AM
-- Design Name: 
-- Module Name: top_module - Behavioral
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

entity Audio_Player_Top is
    Port ( 
           clk : in STD_LOGIC;
           play : in STD_LOGIC;
           stop : in STD_LOGIC;
           audio_out : out STD_LOGIC
         );
end Audio_Player_Top;

architecture Behavioral of Audio_Player_Top is

    signal enable : STD_LOGIC;
    signal reset : STD_LOGIC;
    signal sample_tick : STD_LOGIC;
    signal sample_data : STD_LOGIC_VECTOR(15 downto 0);

begin

    play_ctrl: entity work.play_controller
        port map (
            play => play,
            stop => stop,
            clk => clk,
            enable => enable,
            reset => reset
        );

    sample_timer: entity work.sample_timer
        port map (
            clk => clk,
            enable => enable,
            sample_tick => sample_tick
        );

    bram_ctrl: entity work.bram_controller
        port map (
            clk => clk,
            address => open, 
            sample_data => sample_data
        );

    audio_out_mod: entity work.audio_output
        port map (
            clk => clk,
            sample_data => sample_data,
            audio_out => audio_out
        );

end Behavioral;
