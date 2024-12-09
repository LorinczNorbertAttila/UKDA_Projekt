----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2024 10:17:55 AM
-- Design Name: 
-- Module Name: bram_controller - Behavioral
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

entity bram_controller is
    port (
        clk         : in  STD_LOGIC;         
        reset       : in  STD_LOGIC;         
        sample_tick : in  STD_LOGIC;         
        write_enable: in  STD_LOGIC;        
        write_data  : in  STD_LOGIC_VECTOR(31 downto 0); 
        write_address : in  STD_LOGIC_VECTOR(12 downto 0); 
        read_address  : in  STD_LOGIC_VECTOR(12 downto 0); 
        douta       : in  STD_LOGIC_VECTOR(31 downto 0); 
        sample_data : out STD_LOGIC_VECTOR(31 downto 0); 
        addra       : out STD_LOGIC_VECTOR(12 downto 0); 
        dina        : out STD_LOGIC_VECTOR(31 downto 0); 
        ena         : out STD_LOGIC;         
        wea         : out STD_LOGIC);
end entity BRAM_Controller;

architecture Behavioral of BRAM_Controller is
    -- Állapot típus deklaráció
    type state_type is (INIT, IDLE, WRITE, READ, OUTPUT);
    signal state, next_state : state_type;

    -- Regiszterek az adatok tárolására
    signal temp_sample_data : STD_LOGIC_VECTOR(31 downto 0);
begin

    -- Állapotgép folyamat
    process (clk, reset)
    begin
        if reset = '1' then
            state <= INIT;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Következ? állapot logika
    process (state, sample_tick, write_enable)
    begin
        -- Alapértékek
        next_state <= state;
        
        case state is
            when INIT =>
                next_state <= IDLE;

            when IDLE =>
                if write_enable = '1' then
                    next_state <= WRITE;
                elsif sample_tick = '1' then
                    next_state <= READ;
                end if;

            when WRITE =>
                next_state <= IDLE;

            when READ =>
                next_state <= OUTPUT;

            when OUTPUT =>
                next_state <= IDLE;

            when others =>
                next_state <= IDLE;
        end case;
    end process;

    -- Kimeneti logika
    process (state, write_data, write_address, read_address, douta)
    begin
        -- Alapértékek
        ena <= '0';
        wea <= '0';
        addra <= (others => '0');
        dina <= (others => '0');
        sample_data <= (others => '0');
        
        case state is
            when WRITE =>
                ena <= '1';
                wea <= '1';
                addra <= write_address;
                dina <= write_data;

            when READ =>
                ena <= '1';
                wea <= '0';
                addra <= read_address;

            when OUTPUT =>
                sample_data <= douta;     -- Kiadás a sample_data vonalra

            when others =>
                ena <= '0';
                wea <= '0';
        end case;
    end process;

end architecture Behavioral;

