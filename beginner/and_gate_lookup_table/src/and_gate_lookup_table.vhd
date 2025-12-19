----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2025 05:30:17 PM
-- Design Name: 
-- Module Name: and_gate_lookup_table - lookup_table
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- mimics an AND gate using a lookup table.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity and_gate_lookup_table is
    port(
        sw : in std_logic_vector(1 downto 0);
        led : out std_logic_vector(0 downto 0)
    );
end entity and_gate_lookup_table;

architecture lookup_table of and_gate_lookup_table is
begin
    led <= (0 => sw(0) and sw(1));  -- because led is a 1-bit vector, we AND sw(0) and sw(1) and put it in index 0 of the vector
                                    -- that is why "=>" is used here
end architecture lookup_table;
