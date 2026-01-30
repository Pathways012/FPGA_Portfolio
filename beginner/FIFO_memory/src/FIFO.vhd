----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2026 11:25:41 AM
-- Design Name: 
-- Module Name: FIFO - RTL
-- Project Name: FIFO 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- An implementation of FIFO memory, reusing the earlier dual-port RAM module
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   -- included for functions used in DEPTH_BITS
use ieee.math_real.all;     -- included for functions used in DEPTH_BITS

entity FIFO is
    generic(
        WIDTH : integer := 8;  -- there are 8 parallel queues
        DEPTH : integer := 256  -- each queue is 256 bits (6-transistor SRAM cells in common BRAM implementations) long
    );
    port(
        i_clk : in std_logic;   -- clock
        i_rst : in std_logic;   -- reset signal
        -- write side
        i_write_data_valid : in std_logic;      -- tells the FIFO to accept the input data
        i_write_data : in std_logic_vector(WIDTH - 1 downto 0);   -- make sure the data width matches the width of the memory you're trying to write it to
        i_almost_full_level : in std_logic;    -- ?
        o_almost_full_flag : out std_logic;     -- when writing to memory in chunks, make sure there are enough bits left to write the whole chunk; should be high when there is only 1 empty chunk left in the FIFO
        o_full : out std_logic;     -- signals full when the FIFO is full
        -- read side
        i_read_enable : in std_logic;   -- allows external modules to read from FIFO
        o_read_data_valid : out std_logic;  --  tells the external module the data is ready
        o_read_data : out std_logic_vector(WIDTH - 1 downto 0);     -- the data
        i_almost_empty_level : in std_logic;    -- ?
        o_almost_empty_flag : out std_logic;    -- signals when there is one chunk left to read in the FIFO
        o_empty : out std_logic     -- signals the FIFO is empty
    );
end entity FIFO;


architecture RTL of FIFO is
    constant DEPTH_BITS : integer := integer(ceil(log2(real(DEPTH))));  -- convert DEPTH to a float, then base 2, then round up, then back to an integer
                                                                        -- helper constant that allows the generic WIDTH to be used, making it possible to parameterize this FIFO implementation.
    signal r_write_address, r_read_address : natural range 0 to DEPTH - 1;  -- "natural" numbers are non-negative integers. These are the read and write address pointers.
    signal r_count : natural range 0 to DEPTH;      -- 1 extra to go to DEPTH
    
    signal w_read_data_valid : std_logic;   -- WHEN YOU COME BACK, START HERE
    signal w_read_data : std_logic_vector(WIDTH - 1 downto 0);
    
    signal w_read_address, w_write_address : std_logic_vector(DEPTH_BITS - 1 downto 0);
    
    
begin

    w_write_address <= std_logic_vector(to_unsigned(r_write_address, DEPTH_BITS));
    w_read_address <= std_logic_vector(to_unsigned(r_read_address, DEPTH_BITS));
    
    -- instance the dual-port RAM
    RAM_instance : entity work.dual_port_RAM
        generic map(
            WIDTH => WIDTH,
            DEPTH => DEPTH
        )
        port map(
            -- write side
            i_write_clk => i_clk,
            i_write_address => w_write_address,
            i_write_data_valid => i_write_data_valid,
            i_write_data => i_write_data,
            -- read side
            i_read_clk => i_clk,
            i_read_address => w_read_address,
            i_read_enable => i_read_enable,
            o_read_data_valid => w_read_data_valid,
            o_read_data => w_read_data
        );
        
  -- Main process to control address and counters for FIFO
  process (i_clk, i_rst) is
  begin
    if not i_rst then
      r_write_address <= 0;
      r_read_address <= 0;
      r_count   <= 0;
    elsif rising_edge(i_clk) then
      
      -- write side
      if i_write_data_valid then
        if r_write_address = DEPTH-1 then
          r_write_address <= 0;
        else
          r_write_address <= r_write_address + 1;
        end if;
      end if;

      -- read side
      if i_read_enable then
        if r_read_address = DEPTH-1 then
          r_read_address <= 0;
        else
          r_read_address <= r_read_address + 1;
        end if;
      end if;

      -- Keeps track of number of words in FIFO
      -- Read with no write
      if i_read_enable = '1' and i_write_data_valid = '0' then
        if (r_count /= 0) then
          r_count <= r_count - 1;
        end if;
      -- Write with no read
      elsif i_write_data_valid = '1' and i_read_enable = '0' then
        if r_count /= DEPTH then
          r_count <= r_count + 1;
        end if;
      end if;

      if i_read_enable = '1' then
        o_read_data <= w_read_data;
      end if;

    end if;
  end process;

  o_full <= '1' when ((r_count = DEPTH) or (r_count = DEPTH-1 and i_write_data_valid = '1' and i_read_enable = '0')) else '0';
  
  o_empty <= '1' when (r_count = 0) else '0';

  o_almost_full_flag <= '1' when (r_count > DEPTH - i_almost_full_level) else '0';
  o_almost_empty_flag <= '1' when (r_count < i_almost_empty_level) else '0';

  o_read_data_valid <= w_read_data_valid;
    
    
end architecture RTL;
