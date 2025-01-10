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
use IEEE.NUMERIC_STD.ALL;

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
           reset: in STD_LOGIC;
           audio_pwm : out STD_LOGIC;
           audio_sd : out STD_LOGIC);
end audio_output;

architecture Behavioral of audio_output is

    --Bels? jelek
    signal audio_left  : STD_LOGIC_VECTOR(15 downto 0);
    signal pwm_counter : unsigned(15 downto 0) := (others => '0');
    signal sample_tick : STD_LOGIC := '0';
    signal sample_counter : integer range 0 to 1000 := 0;

begin
    -- Mintavételi frekvencia
    process(clk)
    begin
        if rising_edge(clk) then
            if sample_counter = 2267 then -- 100 MHz / 44.1 kHz
                sample_counter <= 0;
                sample_tick <= '1';
            else
                sample_counter <= sample_counter + 1;
                sample_tick <= '0';
            end if;
        end if;
    end process;

    -- Audio adatok feldolgozása
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                audio_left <= (others => '0');
            elsif sample_tick = '1' then
                audio_left <= sample_data(31 downto 16);
            end if;
        end if;
    end process;

    -- PWM generálás
    process(clk)
    begin
        if rising_edge(clk) then
            pwm_counter <= pwm_counter + 1;
            if pwm_counter < unsigned(audio_left) then
                audio_pwm <= '1';
            else
                audio_pwm <= '0';
            end if;
        end if;
    end process;

    -- Audio er?sít? engedélyezése
    audio_sd <= '1';
end Behavioral;
