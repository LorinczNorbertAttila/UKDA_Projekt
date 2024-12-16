----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2024 20:35:35
-- Design Name: 
-- Module Name: bram_controller_sim - Behavioral
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

entity bram_controller_sim is
--  Port ( );
end bram_controller_sim;

architecture Behavioral of bram_controller_sim is

    -- A DUT (Device Under Test) portjainak jelei
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal sample_tick : std_logic := '0';
    signal write_enable: std_logic := '0';
    signal write_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal write_address : std_logic_vector(12 downto 0) := (others => '0');
    signal read_address  : std_logic_vector(12 downto 0) := (others => '0');
    signal douta       : std_logic_vector(31 downto 0) := (others => '0');
    signal sample_data : std_logic_vector(31 downto 0);
    signal addra       : std_logic_vector(12 downto 0);
    signal dina        : std_logic_vector(31 downto 0);
    signal ena         : std_logic;
    signal wea         : std_logic;

    -- Órajel generálás (50 MHz)
    constant clk_period : time := 10 ns;

begin

    -- Órajel folyamat
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Példányosítás (DUT, azaz a bram_controller modul)
    DUT: entity work.bram_controller
        port map (
            clk => clk,
            reset => reset,
            sample_tick => sample_tick,
            write_enable => write_enable,
            write_data => write_data,
            write_address => write_address,
            read_address => read_address,
            douta => douta,
            sample_data => sample_data,
            addra => addra,
            dina => dina,
            ena => ena,
            wea => wea
        );

    -- Teszt szekvencia
    stimulus_process: process
    begin
        -- Reset alkalmazása
        reset <= '1';
        wait for 2 * clk_period;
        reset <= '0';
        
        -- Olvasási teszt 1: Cím 0x001 (COE el?re betöltött adat)
        read_address <= "0000000000001"; -- 1-es cím
        sample_tick <= '1';
        wait for clk_period;
        sample_tick <= '0';
        wait for clk_period;

        -- Figyeljük az olvasott adatot
        assert sample_data = douta report "Hiba: Olvasott adat nem egyezik a BRAM tartalmával!" severity error;

        -- Olvasási teszt 2: Cím 0x002
        read_address <= "0000000000010"; -- 2-es cím
        sample_tick <= '1';
        wait for clk_period;
        sample_tick <= '0';
        wait for clk_period;

        -- Figyeljük az olvasott adatot
        assert sample_data = douta report "Hiba: Olvasott adat nem egyezik a BRAM tartalmával!" severity error;

        -- Szimuláció vége
        wait for 10 * clk_period;
        report "Szimuláció vége." severity note;
        wait;
    end process;

end architecture Behavioral;



