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

    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal sample_tick : std_logic := '0';
    signal write_enable: std_logic := '0';
    signal write_data : std_logic_vector(31 downto 0) := (others => '0');
    signal write_address : std_logic_vector(12 downto 0) := (others => '0');
    signal read_address : std_logic_vector(12 downto 0) := (others => '0');
    signal douta : std_logic_vector(31 downto 0) := (others => '0');
    signal sample_data : std_logic_vector(31 downto 0);
    signal addra : std_logic_vector(12 downto 0);
    signal dina : std_logic_vector(31 downto 0);
    signal ena : std_logic;
    signal wea : std_logic;

    constant clk_period : time := 20 ns;

begin

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    controller: entity work.bram_controller
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
        -- Reset alkalmaz�sa
        reset <= '1';
        wait for 2 * clk_period;
        reset <= '0';
        
        -- Olvas�si teszt 1
        read_address <= "0000000000001"; -- 1-es c�m
        sample_tick <= '1';
        wait for clk_period;
        sample_tick <= '0';
        wait for clk_period;

        -- Olvas�si teszt 2
        read_address <= "0000000000010"; -- 2-es c�m
        sample_tick <= '1';
        wait for clk_period;
        sample_tick <= '0';
        wait for clk_period;
        
        -- Szimul�ci� v�ge
        wait for 10 * clk_period;
        wait;
    end process;

end architecture Behavioral;



