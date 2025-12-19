----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2025 03:20:17 AM
-- Design Name: 
-- Module Name: debouncer_v2 - RTL
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- a debouncing module, different than the previously created one.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   -- included to allow use of the "range" keyword

entity debouncer_v2 is
    generic(
        DEBOUNCE_LIMIT : integer := 20  -- declare a generic for tracking the number of bounces and initialize to 20
    );   
    port(
        clk : in std_logic; -- clock
        bouncy : in std_logic_vector(0 downto 0);   -- bouncy switch signal
        debounced : out std_logic   -- debounced signal
    );
end entity debouncer_v2;


architecture RTL of debouncer_v2 is
    signal count : integer range 0 to DEBOUNCE_LIMIT := 0;  -- register for the counter variable. the range statement figures out how many bits are needed. For 20, 5 bits will be needed.
    signal state : std_logic := '0';    -- variable for holding the switch's state from the previous clock cycle. defaults to 0 or "off" so it will not trigger until the switch has been turned on at least once.
begin
    process (clk) is    -- pass the clock signal to the process to make it usable inside
    begin
        if rising_edge (clk) then   -- on the rising edge of the clock
            if (bouncy(0) /= state and count < DEBOUNCE_LIMIT - 1) then     -- if the current switch signal is not equal to the state it was in during the previous clock cycle,
                count <= count + 1; -- increment the counter                -- and the counter hasn't hit the number of debounces needed to count as stable yet
            elsif count = DEBOUNCE_LIMIT - 1 then   -- if the switch signal has been stable for count clock cycles
                state <= bouncy(0); -- change state to match the switch signal
                count <= 0; -- reset the counter
            else -- 
                count <= 0; -- reset the counter
            end if;
        end if;
    end process;
    
debounced <= state; -- set debounced to match state

end RTL;
