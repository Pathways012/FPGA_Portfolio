----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2025 09:32:24 PM
-- Design Name: 
-- Module Name: four_to_one_demux - RTL
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- a 4-to-1 demultiplexer
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity four_to_one_demux is
    port(
        i_data : in std_logic;  -- incoming data
        i_selector1 : in std_logic; -- selector 1
        i_selector2 : in std_logic; -- selector 2
        o_data0 : out std_logic;    -- data out 1
        o_data1 : out std_logic;    -- data out 2
        o_data2 : out std_logic;    -- data out 3
        o_data3 : out std_logic     -- data out 4
    );
end entity four_to_one_demux;

architecture RTL of four_to_one_demux is
begin
    o_data0 <= i_data when i_selector1 = '0' and i_selector2 = '0' else '0';    -- send the input to data0 when both selectors are low
    o_data1 <= i_data when i_selector1 = '0' and i_selector2 = '1' else '0';    -- send the input to data1 when selector1 is low and and selector2 is high
    o_data2 <= i_data when i_selector1 = '1' and i_selector2 = '0' else '0';    -- send the input to data2 when selector1 is high and selector2 is low
    o_data3 <= i_data when i_selector1 = '1' and i_selector2 = '1' else '0';    -- send the input to data3 when both selectors are high
end architecture RTL;
