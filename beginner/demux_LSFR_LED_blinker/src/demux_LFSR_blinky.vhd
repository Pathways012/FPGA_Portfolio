----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2025 10:12:28 PM
-- Design Name: 
-- Module Name: demux_LSFR_blinky - RTL
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- Toggle which of 4 LEDs is blinking by using the input of 2 switches
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity demux_LSFR_blinky is
    port(
        clk : in std_logic;
        sw : in std_logic_vector(1 downto 0);
        led : out std_logic_vector(3 downto 0)
    );
end entity demux_LSFR_blinky;

architecture RTL of demux_LSFR_blinky is
    signal r_LFSR_toggle : std_logic :='0';
    signal w_LFSR_done : std_logic;
begin
    LFSR : entity work.linear_feedback_shift_register
    port map(
        clk => clk,
        o_LFSR_data => open,
        o_LFSR_done => w_LFSR_done
    );
    process (clk) is
    begin
        if rising_edge(clk) then
            if w_LFSR_done = '1' then   -- if the done pulse was sent
                r_LFSR_toggle <= not r_LFSR_toggle; -- toggle the LED
            end if;
        end if;
    end process;

    demux_instance : entity work.four_to_one_demux
    port map(
        i_data => r_LFSR_toggle,    -- input from toggle module
        i_selector1 => sw(0),   -- two bits for switch vector
        i_selector2 => sw(1),
        o_data0 => led(0),  -- four bits for LED vector
        o_data1 => led(1),
        o_data2 => led(2),
        o_data3 => led(3)
    );
end architecture RTL;
