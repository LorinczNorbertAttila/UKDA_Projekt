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
    signal temp_data : STD_LOGIC_VECTOR(31 downto 0); -- Ideiglenes tároló az adatokhoz

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
        -- Alapértelmezett értékek
        audio_out <= (others => '0');  
        temp_data <= (others => '0');

        case current_state is
            
            when INIT =>
                next_state <= IDLE;
        
            when RDY => 
                if sample_data /= X"00000000" then
                    next_state <= IDLE;
                else
                    next_state <= RDY;
                end if;
                
            when IDLE => 
                temp_data <= sample_data;
                next_state <= PROCESSING;
                
            when PROCESSING => 
                next_state <= OUTPUT;
                
            when OUTPUT =>
                audio_out <= temp_data;
                next_state <= INIT;  
                
        end case;
    end process;




end Behavioral;
