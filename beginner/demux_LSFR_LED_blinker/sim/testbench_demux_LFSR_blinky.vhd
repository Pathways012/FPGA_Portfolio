----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2025 06:50:19 AM
-- Design Name: 
-- Module Name: testbench_demux_LSFR_blinky - test
-- Project Name: 
-- Target Devices: Basys 3 
-- Tool Versions: 
-- Description: 
-- Testbench for the demux_LSFR_blinky top-level module.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.finish;

entity testbench_demux_LSFR_blinky is
end entity;

architecture test of testbench_demux_LSFR_blinky is
    signal clk : std_logic := '0';
    signal sw  : std_logic_vector(1 downto 0) := (others => '0');
    signal led : std_logic_vector(3 downto 0);

begin
    clk <= not clk after 1ns;   -- simulated a 2ns clock period

    UUT : entity work.demux_LSFR_blinky -- instantiate the top-level module
        port map (
            clk => clk,
            sw  => sw,
            led => led
        );

    process is
    begin
        sw <= "00";
        wait for 250 ns;    -- wait to observe blinking

        sw <= "01";
        wait for 250 ns;

        sw <= "10";
        wait for 250 ns;

        sw <= "11";
        wait for 250 ns;
        finish;
    end process;

end architecture test;
