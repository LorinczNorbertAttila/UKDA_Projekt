----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2024 20:25:53
-- Design Name: 
-- Module Name: top_modul_sim - Behavioral
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

entity top_module_sim is
--  Port ( );
end top_module_sim;

architecture Behavioral of top_module_sim is

    component top_module
        port (
            clk       : in  STD_LOGIC;
            reset     : in  STD_LOGIC;
            play      : in  STD_LOGIC;
            stop      : in  STD_LOGIC;
            audio_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal clk_sim       : STD_LOGIC := '0';
    signal reset_sim     : STD_LOGIC := '0';
    signal play_sim      : STD_LOGIC := '0';
    signal stop_sim      : STD_LOGIC := '0';
    signal audio_out_sim : STD_LOGIC_VECTOR(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    UUT: top_module
        port map (
            clk       => clk_sim,
            reset     => reset_sim,
            play      => play_sim,
            stop      => stop_sim,
            audio_out => audio_out_sim
        );

    clk_process : process
    begin
        while true loop
            clk_sim <= '0';
            wait for clk_period / 2;
            clk_sim <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus_process : process
    begin
        reset_sim <= '1';
        wait for 20 ns;
        reset_sim <= '0';

        play_sim <= '1';
        wait for 100 ns;

        stop_sim <= '1';
        wait for 50 ns;

        play_sim <= '0';
        stop_sim <= '0';
        wait for 100 ns;

        assert false report "Szimuláció vége" severity failure;
    end process;

end Behavioral;
