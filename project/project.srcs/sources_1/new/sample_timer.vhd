----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2024 10:19:16 AM
-- Design Name: 
-- Module Name: sample_timer - Behavioral
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

entity sample_timer is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           sample_tick : out STD_LOGIC);
end sample_timer;

architecture Behavioral of sample_timer is

    -- Állapotok típusa
    type state_type is (INIT, RDY, COUNTING, TICK, WAITING);
    signal current_state, next_state : state_type;
    
    constant max_count : integer := 2267; -- Például 100 MHz / 44.1 kHz
    signal counter : integer := 0;

begin
    
    -- Állapotregiszter frissítése
    process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    -- Állapotgép m?ködése
    process(current_state, enable, counter)
    begin
        case current_state is
            when INIT =>
                if enable = '1' then
                    next_state <= RDY;
                else
                    next_state <= INIT;
                end if;
            when RDY =>
                next_state <= COUNTING;
            when COUNTING =>
                if counter = max_count then
                    next_state <= TICK;
                else
                    next_state <= COUNTING;
                end if;
            when TICK =>
                next_state <= WAITING;
            when WAITING =>
                next_state <= COUNTING;
            when others =>
                next_state <= INIT;
        end case;
    end process;

    -- Számláló m?ködése
    process(clk)
    begin
        if rising_edge(clk) then
            if current_state = COUNTING then
                if counter = max_count then
                    counter <= 0; -- Ha eléri a max értéket akkor lenullázzuk
                else
                    counter <= counter + 1;
                end if;
            else
                counter <= 0;
            end if;
        end if;
    end process;
    
    -- sample tick jel generálása
    process(current_state)
    begin
        if current_state = TICK then
            sample_tick <= '1';
        else
            sample_tick <= '0';
        end if;
    end process;

end Behavioral;
