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

 
    -- BRAM Controller Komponens
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

    -- Block Memory Generator Komponens
    component blk_mem_gen_0
        port (
            clka : in  STD_LOGIC;
            ena : in  STD_LOGIC;
            wea : in  STD_LOGIC_VECTOR(0 downto 0);
            addra : in  STD_LOGIC_VECTOR(12 downto 0);
            dina : in  STD_LOGIC_VECTOR(31 downto 0);
            douta : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- Jelek
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal sample_tick : STD_LOGIC := '0';
    signal write_enable : STD_LOGIC := '0';
    signal write_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal write_address: STD_LOGIC_VECTOR(12 downto 0) := (others => '0');
    signal read_address : STD_LOGIC_VECTOR(12 downto 0) := (others => '0');
    signal douta : STD_LOGIC_VECTOR(31 downto 0);
    signal sample_data : STD_LOGIC_VECTOR(31 downto 0);
    signal addra : STD_LOGIC_VECTOR(12 downto 0);
    signal dina : STD_LOGIC_VECTOR(31 downto 0);
    signal ena : STD_LOGIC;
    signal wea : STD_LOGIC_VECTOR(0 downto 0);

    -- BRAM jelek
    signal bram_ena : STD_LOGIC;
    signal bram_wea : STD_LOGIC_VECTOR(0 downto 0);
    signal bram_addra : STD_LOGIC_VECTOR(12 downto 0);
    signal bram_dina : STD_LOGIC_VECTOR(31 downto 0);
    signal bram_douta : STD_LOGIC_VECTOR(31 downto 0);

    -- Órajel periódus
    constant clk_period : time := 10 ns;

begin

    -- BRAM Controllert
    controller: bram_controller
        port map (
            clk => clk,
            reset => reset,
            sample_tick => sample_tick,
            write_enable => write_enable,
            write_data => write_data,
            write_address => write_address,
            read_address => read_address,
            douta => bram_douta,
            sample_data => sample_data,
            addra => bram_addra,
            dina => bram_dina,
            ena => bram_ena,
            wea => bram_wea
        );

    -- Block Memory Generatort
    bram: blk_mem_gen_0
        port map (
            clka => clk,
            ena => bram_ena,
            wea => bram_wea,
            addra => bram_addra,
            dina => bram_dina,
            douta => bram_douta
        );

    -- Órajel generálás
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Teszt folyamat
    sim: process
    begin
        -- Reset
        reset <= '1';
        wait for 5 * clk_period;
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- Olvasási m?velet
        for i in 0 to 10 loop
            sample_tick <= '1';
            read_address <= STD_LOGIC_VECTOR(to_unsigned(i, 13));  -- Olvasási cím
            wait for clk_period;
            sample_tick <= '0';
            wait for clk_period;
            
        end loop;

        -- Teszt vége
        wait for 10 * clk_period;
    end process;

end Behavioral;


