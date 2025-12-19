----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2025 09:32:24 PM
-- Design Name: 
-- Module Name: linear_feedback_shift_register - RTL
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- a 24-bit linear feedback shift register
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity linear_feedback_shift_register is
    port(
        clk : in std_logic;
        o_LFSR_data : out std_logic_vector(23 downto 0);    -- placeholder to enable sending the data in the register onward. Not used in this project.
        o_LFSR_done : out std_logic -- the pulse being sent each time the register hits all zeroes
    );
end entity linear_feedback_shift_register;

architecture RTL of linear_feedback_shift_register is
    signal r_LFSR : std_logic_vector(23 downto 0) := "000000000000000000000001";  -- the 24-bit register
    signal w_XNOR : std_logic;  -- the XNOR gate
    signal r_LFSR_old_bit : std_logic := '0';   -- added to track the previous MSB for simulation purposes
begin
    process (clk)
    begin
        if rising_edge(clk) then
            r_LFSR <= r_LFSR(22 downto 0) & w_XNOR; -- shift the register one bit left and concatenate the XNOR output into the rightmost bit
            r_LFSR_old_bit <= r_LFSR(23);   -- added to track the previous MSB for simulation purposes
        end if;
    end process;

w_XNOR <= r_LFSR(23) xnor r_LFSR(22);   -- XNOR the two most significant bits in the register
--o_LFSR_done <= '1' when (r_LFSR = "000000000000000000000000") else '0'; -- when the register is all zeroes, send a pulse
o_LFSR_done <= '1' when (r_LFSR(23) = '0' and r_LFSR_old_bit = '1') else '0';    -- for simulation: when the MSB has dropped to 0 from 1, send the "done" pulse
o_LFSR_data <= r_LFSR;  -- put the data in the register on an output signal. Not used in this project.

end architecture RTL;
