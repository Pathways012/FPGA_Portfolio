----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2025 04:08:25 AM
-- Design Name: 
-- Module Name: testbench_debouncer_v2_top - RTL
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- Testbench for the debouncer_v2_top module. Simulates a bouncing switch input. 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.env.finish; -- included to allow use of the "finish" keyword

entity testbench_debouncer_v2_top is
end testbench_debouncer_v2_top;

architecture test of testbench_debouncer_v2_top is
    signal clk, debounced : std_logic := '0';   -- declare the needed signals
    signal bouncy : std_logic_vector(0 downto 0) := (others => '0');
begin
    clk <= not clk after 2ns;   -- simulate a clock cycle of 2ns (period of 4ns)
    UUT : entity work.debouncer_v2  -- Unit Under Test: debouncer_v2
        generic map(
            DEBOUNCE_LIMIT => 4 -- use a period of 4 clock cycles (16ns)
        )
        port map(
            clk => clk,
            bouncy => bouncy,
            debounced => debounced
        );
process is
begin
    wait for 10 ns;
    bouncy(0) <= '1';  -- switch flips on
    wait until rising_edge(clk);
    bouncy(0) <= '0';  -- switch flips off, simulating a bounce
    wait until rising_edge(clk);
    bouncy(0) <= '1';  -- switch flips on again. After 16ns, this should result in bouncy going high
    wait for 24 ns;
    finish; 
end process;

end test;
