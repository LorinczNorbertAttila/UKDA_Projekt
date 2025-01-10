----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2024 18:42:30
-- Design Name: 
-- Module Name: top_modul - Behavioral
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

entity top_modul is
    Port ( clk : in STD_LOGIC;
           play : in STD_LOGIC;
           stop : in STD_LOGIC;
           pause : in STD_LOGIC;
           audio_pwm : out STD_LOGIC;
           audio_sd : out STD_LOGIC);
end top_modul;

architecture Behavioral of top_modul is

-- Komponens deklarációk

    component blk_mem_gen_0
        port (
            clka : in  STD_LOGIC;
            ena : in  STD_LOGIC;
            wea : in  STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : in  STD_LOGIC_VECTOR(12 DOWNTO 0);
            dina : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            douta : out STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;
    
    component bram_controller
        port (
            clk : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            sample_tick : in  STD_LOGIC;
            write_enable : in  STD_LOGIC;
            write_data : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_address: in  STD_LOGIC_VECTOR(12 DOWNTO 0);
            read_address : in  STD_LOGIC_VECTOR(12 DOWNTO 0);
            douta : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            sample_data : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            addra : out STD_LOGIC_VECTOR(12 DOWNTO 0);
            dina : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            ena : out STD_LOGIC;
            wea : out STD_LOGIC_VECTOR(0 DOWNTO 0)
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
            sample_data : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
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

    -- Bels? jelek
    signal enable_signal : STD_LOGIC;
    signal reset_signal : STD_LOGIC;
    signal sample_tick_signal : STD_LOGIC;
    signal bram_sample_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal douta_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal read_address_signal : STD_LOGIC_VECTOR (12 DOWNTO 0);
    signal addra_signal : STD_LOGIC_VECTOR(12 DOWNTO 0);
    signal dina_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal ena_signal : STD_LOGIC;
    signal wea_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal read_address_counter : STD_LOGIC_VECTOR(12 DOWNTO 0) := (others => '0');

begin

    -- Számláló logika: növeli a read_address értékét sample tick-re
    process (clk, reset_signal)
    begin
        if reset_signal = '1' then
            read_address_counter <= (others => '0');  
        elsif rising_edge(clk) then
            if sample_tick_signal = '1' then
                if read_address_counter = "1111111111111" then
                    read_address_counter <= (others => '0');  
                else
                    read_address_counter <= std_logic_vector(unsigned(read_address_counter) + 1);
                end if;
            end if;
        end if;
    end process;
    
    read_address_signal <= read_address_counter;

    -- Play controller kapcsolás
    playing : play_controller
        port map (
            play => play,
            stop => stop,
            pause => pause,
            clk => clk,
            enable => enable_signal,
            reset => reset_signal
        );

    -- Sample timer kapcsolás
    timer : sample_timer
        port map (
            clk => clk,
            enable => enable_signal,
            reset => reset_signal,
            sample_tick => sample_tick_signal
        );

    -- BRAM controller kapcsolás
    read : bram_controller
        port map (
            clk => clk,
            reset => reset_signal,
            sample_tick => sample_tick_signal,
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

    -- Audio output kapcsolás
    audio : audio_output
        port map (
            sample_data => bram_sample_data,
            clk => clk,
            reset => reset_signal,
            audio_pwm => audio_pwm,
            audio_sd => audio_sd
        );

    -- BRAM modul kapcsolás
    bram : blk_mem_gen_0
        port map (
            clka => clk,
            ena => ena_signal,
            wea => wea_signal,
            addra => addra_signal,
            dina => dina_signal,
            douta => douta_signal
        );  

end Behavioral;
