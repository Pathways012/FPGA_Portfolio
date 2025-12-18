----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2025 02:47:40 AM
-- Design Name: 
-- Module Name: LED_toggle - Behavioral
-- Project Name: 
-- Target Devices: Basys 3 
-- Tool Versions: 
-- Description: 
-- uses a pair of flipflops to detect the falling edge of a switch input and toggle an LED on/off.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity LED_toggle is
    port(
        clk: in std_logic;
        sw : in std_logic_vector(0 downto 0);   -- declare the switch and led as vectors of 1 (done due to declaration as vectors in the master .xdc file)
        led : out std_logic_vector(0 downto 0)
    );
end entity LED_toggle;


architecture RTL of LED_toggle is
    signal led_flip_flop : std_logic := '0';    -- initialize both flipflops with 0
    signal switch_flip_flop : std_logic := '0';
begin
    process (clk) is
    begin
        if rising_edge(clk) then    -- on the rising edge of the clock
            switch_flip_flop <= sw(0);  -- read the switch output into the switch flipflop
            if sw(0) = '0' and switch_flip_flop = '1' then  -- if the switch is now 0 and the previous reading was 1 (the falling edge of the switch)
                led_flip_flop <= not led_flip_flop; -- toggle the LED flipflop
            end if;
        end if;
    end process;
    
    led(0) <= led_flip_flop;    -- use the output of the LED flipflop to turn the LED on/off
    
end architecture RTL;
