----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/22/2025 01:21:15 PM
-- Design Name: 
-- Module Name: dual_port_RAM - RTL
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- An implementation of dual port RAM. Total bits: 4096
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_port_RAM is
    generic(
        WIDTH : integer := 16;  -- initialize with a generic for 16-bit registers
        DEPTH : integer := 256  -- initialize with a generic for 256 rows of registers
    );
    port(
        -- WRITE SIGNALS
        i_write_clk : in std_logic;
        i_write_address : in std_logic_vector;  -- sized in a top-level module when this is instantiated. requires enough bits to reference every possible address.
                                                -- for example if DEPTH = 128, then you would need to 2^7 possible addresses; therefore you would make the vector 7 wide 
        i_write_data_valid : in std_logic;  -- used as a signal to tell another module to look at what is on i_write_data
        i_write_data : in std_logic_vector(WIDTH - 1 downto 0);  -- a vector to be written, whose width is determined by the generic WIDTH
        -- READ SIGNALS
        i_read_clk : in std_logic;
        i_read_address : in std_logic_vector;  -- sized in a top-level module when this is instantiated. requires enough bits to reference every possible address.
                                               -- for example if DEPTH = 128, then you would need to 2^7 possible addresses; therefore you would make the vector 7 wide
        i_read_enable : in std_logic;   -- COME BACK TO THIS
        o_read_data_valid : out std_logic;  -- used as a signal to tell another module to look at what is on o_read_data
        o_read_data : out std_logic_vector(WIDTH - 1 downto 0)  -- a vector to be read, whose width is determined by the generic WIDTH
    );
begin
end entity dual_port_RAM;


architecture RTL of dual_port_RAM is
    type total_memory is array (0 to DEPTH - 1) of std_logic_vector(WIDTH - 1 downto 0);    -- use "type" to declare a custom data type; in this case a 2D array of vectors for WIDTH registers * DEPTH rows 
    signal RAM_memory : total_memory;
begin
    process(i_write_clk)    -- on the write port's clock
    begin
        if rising_edge(i_write_clk) then
            if i_write_data_valid = '1' then    -- if i_write_data_valid is high
                RAM_memory(to_integer(unsigned(i_write_address))) <= i_write_data;  -- convert i_write_address to an integer in RAM_memory's array index, then write the data to that index
                                                                                    -- this is very similar to updating a value at a specific index in an array, just with memory
                                                                                    -- "to_integer" + "unsigned" tells VHDL to treat the contents of i_write_address as an unsigned integer,
                                                                                    -- which is needed for using the integer as an index in RAM_memory
            end if;
        end if;
    end process;
    
    process(i_read_clk) -- on the read port's clock
    begin
        if rising_edge(i_read_clk) then
            o_read_data <= RAM_memory(to_integer(unsigned(i_read_address)));    -- send the contents at i_read_address (as an unsigned integer) from RAM_memory to o_read_data
            o_read_data_valid <= i_read_enable; -- give o_read_data_valid the same value as i_read_enable
            
                                                -- the above reads data into o_read_data every clock cycle, but it is only passed along if i_read_enable is high
                                                -- i_read_enable (input from external module) will set o_read_data_valid (output from this module)
                                                -- one cycle later, telling the external module its data is ready to read at the same time the data is available.
        end if;
    end process;

end architecture RTL;
