----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2025 03:43:58 AM
-- Design Name: 
-- Module Name: testbench_and_gate_lookup_table - Behavioral
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- testbench for the and_gate_lookup_table module.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.finish; -- included to allow use of "finish" on line 54

entity testbench_and_gate_lookup_table is   -- no entity is used here; not using any physical components
end testbench_and_gate_lookup_table;

architecture Behavioral of testbench_and_gate_lookup_table is
    signal sw0, sw1, led : std_logic;   -- declare all 3 signals as std_logic
begin
    UUT : entity work.and_gate_lookup_table -- UUT = Unit Under Test; this is "work." + entity name from .vhd file
    port map(
        sw(0) => sw0,   -- similar to port();, but using commas instead of semicolons
        sw(1) => sw1,   -- and using the association operator "=>" instead of the assignment operator "<="
        led(0) => led   -- to map the std_logic test signals to bits in the real signals' vectors
    );
    process is
    begin
        sw0 <= '0'; -- do all possible combinations
        sw1 <= '0';
        wait for 10 ns; -- wait a clock cycle
        sw0 <= '0';
        sw1 <= '1';
        wait for 10 ns;
        sw0 <= '1';
        sw1 <= '0';
        wait for 10 ns;
        sw0 <= '1';
        sw1 <= '1';
        wait for 10 ns;
        finish; -- usable from std.env.finish
        
    end process;
end architecture Behavioral;
