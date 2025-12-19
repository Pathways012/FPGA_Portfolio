----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2025 03:48:44 AM
-- Design Name: 
-- Module Name: debouncer_v2_top - Behavioral
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- The top level module for a debounced switch toggling an LED when a falling edge is detected from the switch. Makes use of two submodules in this top module.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity debouncer_v2_top is  -- the top level module
    port(
        clk : in std_logic;
        sw : in std_logic_vector(0 downto 0);
        led : out std_logic_vector(0 downto 0)
    );
end entity debouncer_v2_top;


architecture RTL of debouncer_v2_top is
    signal debounced_switch : std_logic;    -- the input signal?
begin
    debouncer_instance : entity work.debouncer_v2   -- instance of the debouncer
        generic  map(
            DEBOUNCE_LIMIT => 1000000   -- setting this to 1,000,000 with a clock period of 10ns will look for 10ms of constant signal before passing it through
        )
        port map(
            clk => clk, -- clock, same name in top and submodule
            bouncy => sw,   -- input switch signal "sw" from top module passed in as "bouncy" to the submodule
            debounced => debounced_switch   -- output signal "debounced" from submodule passed to top module as "debounced_switch"
        );
    LED_toggle_instance : entity work.LED_toggle    -- instance of the LED toggler
        port map(
            clk => clk, -- clock, same name in top and submodule
            sw(0) => debounced_switch,  -- first bit vector "sw" in top module is associated with the debounced_switch signal of top module
            led => led  -- LED, same name in top and submodule
        );
end architecture RTL;
