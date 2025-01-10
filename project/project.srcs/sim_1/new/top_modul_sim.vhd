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

    -- Komponens deklarációk
    component blk_mem_gen_0
        port (
            clka : in  STD_LOGIC;
            ena : in  STD_LOGIC;
            wea : in  STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : in  STD_LOGIC_VECTOR(12 downto 0);
            dina : in  STD_LOGIC_VECTOR(31 downto 0);
            douta : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component bram_controller
        port (
            clk : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            sample_tick : in  STD_LOGIC;
            write_enable : in  STD_LOGIC;
            write_data : in  STD_LOGIC_VECTOR(31 downto 0);
            write_address: in  STD_LOGIC_VECTOR(12 downto 0);
            read_address : in  STD_LOGIC_VECTOR(12 downto 0);
            douta : in  STD_LOGIC_VECTOR(31 downto 0);
            sample_data : out STD_LOGIC_VECTOR(31 downto 0);
            addra : out STD_LOGIC_VECTOR(12 downto 0);
            dina : out STD_LOGIC_VECTOR(31 downto 0);
            ena : out STD_LOGIC;
            wea : out STD_LOGIC_VECTOR(0 downto 0)
        );
    end component;

    component sample_timer
        port (
            clk : in  STD_LOGIC;
            enable : in  STD_LOGIC;
            reset : in STD_LOGIC;
            sample_tick : out STD_LOGIC
        );
    end component;

    component audio_output
        port (
            sample_data : in  STD_LOGIC_VECTOR(31 downto 0);
            clk : in  STD_LOGIC;
            reset: in STD_LOGIC;
            audio_pwm : out STD_LOGIC;
            audio_sd : out STD_LOGIC
        );
    end component;

    component play_controller
        port (
            play : in  STD_LOGIC;
            stop : in  STD_LOGIC;
            pause : in  STD_LOGIC;
            clk : in  STD_LOGIC;
            enable : out STD_LOGIC;
            reset  : out STD_LOGIC
        );
    end component;

    -- Jelek a teszthez
    signal clk : STD_LOGIC := '0';
    signal play : STD_LOGIC := '0';
    signal stop : STD_LOGIC := '0';
    signal pause : STD_LOGIC := '0';
    signal sample_tick : STD_LOGIC := '0';
    signal enable_signal : STD_LOGIC;
    signal reset_signal : STD_LOGIC;
    signal bram_sample_data : STD_LOGIC_VECTOR(31 downto 0);
    signal douta_signal : STD_LOGIC_VECTOR(31 downto 0);
    signal read_address_signal : STD_LOGIC_VECTOR(12 downto 0);
    signal addra_signal : STD_LOGIC_VECTOR(12 downto 0);
    signal dina_signal : STD_LOGIC_VECTOR(31 downto 0);
    signal ena_signal : STD_LOGIC;
    signal wea_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal audio_pwm : STD_LOGIC;
    signal audio_sd : STD_LOGIC;

    -- Órajel paraméterei
    constant clk_period : time := 10 ns;
    constant sample_tick_period : time := 100 ns;

begin

    -- Órajel generátor
    clk_process : process
    begin
        while True loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;
    

    -- Komponensek összekötése

    playing : play_controller
        port map (
            play => play,
            stop => stop,
            pause => pause,
            clk => clk,
            enable => enable_signal,
            reset => reset_signal
        );

    timer : sample_timer
        port map (
            clk => clk,
            enable => enable_signal,
            reset => reset_signal,
            sample_tick => sample_tick
        );

    read : bram_controller
        port map (
            clk => clk,
            reset => reset_signal,
            sample_tick => sample_tick,
            write_enable => '0',
            write_data => (others => '0'),
            write_address => (others => '0'),
            read_address => read_address_signal,
            douta => douta_signal,
            sample_data => bram_sample_data,
            addra => addra_signal,
            dina => dina_signal,
            ena => ena_signal,
            wea => wea_signal
        ); 

    audio : audio_output
        port map (
            sample_data => bram_sample_data,
            clk => clk,
            reset => reset_signal,
            audio_pwm => audio_pwm,
            audio_sd => audio_sd
        );

    bram : blk_mem_gen_0
        port map (
            clka => clk,
            ena => ena_signal,
            wea => wea_signal,
            addra => addra_signal,
            dina => dina_signal,
            douta => douta_signal
        );

    -- Szimulációs forgatókönyv
    sim_proc: process
    begin
        -- Reset
        wait for 20 ns;

        -- Play
        play <= '1';
        wait for 50 ns;
        play <= '0';
        
        --sample_tick <= '0';
        --wait for clk_period / 2;
        --sample_tick <= '1';
        --wait for clk_period / 2;

        -- Pause
        pause <= '1';
        wait for 50 ns;
        pause <= '0';

        -- Stop
        stop <= '1';
        wait for 50 ns;
        stop <= '0';

        -- Vége
        wait for 1 ms;
        assert false report "End of simulation" severity failure;
    end process;

end Behavioral;
