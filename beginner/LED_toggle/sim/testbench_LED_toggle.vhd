----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2025 05:31:24 AM
-- Design Name: 
-- Module Name: testbench_LED_toggle - test
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- testbench for the LED_toggle module
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.all;

entity testbench_LED_toggle is
end testbench_LED_toggle;

architecture test of testbench_LED_toggle is
    signal clk : std_logic := '0';  -- initialize the clock to 0
    signal sw, led : std_logic_vector(0 downto 0) := (others => '0');   -- initialize sw and led as 1-bit vectors with value 0
begin
    clk <= not clk after 5ns;   -- simulate a 10ns clock period
    UUT : entity work.LED_toggle    -- Unit Under Test: an instance of the LED_toggle submodule
        port map(
            clk => clk, -- all signals will have the same names as in the submodule
            sw => sw,
            led => led
        );

process is
begin
    wait for 12ns;  -- let the first cycle run with both off
    sw(0) <= '1';   -- flip the switch on in the middle of the second clock cycle
    wait for 5ns;   -- I expect to see a 1 cycle delay between the switch's falling edge being detected and the LED toggling
    sw(0) <= '0';   -- flip the switch off
    wait for 10ns;
    sw(0) <= '1';
    wait for 10ns;
    sw(0) <= '0';
    wait for 10ns;
    finish;
end process;

end test;
