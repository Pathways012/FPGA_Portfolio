library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity testbench_dual_port_RAM is
end entity testbench_dual_port_RAM;

architecture test of testbench_dual_port_RAM is

  constant WIDTH : integer := 8;    -- use a much smaller block of RAM for the simulation
  constant DEPTH : integer := 4;

  signal r_clk   : std_logic := '0';
  signal r_write_address : unsigned(1 downto 0) := (others => '0');     -- only 2 bits are needed for addressing 4 rows; declared as a 2-bit unsigned number
  signal r_read_address : unsigned(1 downto 0) := (others => '0');
  signal r_write_data_valid   : std_logic := '0';   -- initialize r_write_data_valid to 0
  signal r_write_data : unsigned(WIDTH-1 downto 0) := (others => '0');  -- create a vector 8 bits wide for holding data to be written
  signal r_read_enable   : std_logic := '0';    -- initialize r_read_enable to 0
  signal w_read_data_valid   : std_logic;
  signal w_read_data : std_logic_vector(WIDTH-1 downto 0);  -- create a vector 8 bits wide for holding data to be read

begin
  r_clk <= not r_clk after 5 ns;    -- simulate a 10ns clock period

  UUT : entity work.dual_port_RAM
    generic map (
      WIDTH => WIDTH,
      DEPTH => DEPTH)
    port map (
      i_write_clk  => r_clk,    -- using similar names to the submodule
      i_write_address => std_logic_vector(r_write_address),     -- cast r_write_address to a vector, then associate it with i_write_address
      i_write_data_valid   => r_write_data_valid,
      i_write_data => std_logic_vector(r_write_data),
      i_read_clk  => r_clk,
      i_read_address => std_logic_vector(r_read_address),
      i_read_enable   => r_read_enable,
      o_read_data_valid   => w_read_data_valid,
      o_read_data => w_read_data);
  
  process is
  begin
    wait until r_clk = '1';
    wait until r_clk = '1'; -- wait 2 clock cycles

    -- Fill memory with an incrementing pattern
    for i in 0 to DEPTH-1 loop  -- loop through each memory address
      r_write_data_valid <= '1';    -- signal to write
      wait until r_clk = '1';   -- wait until the next rising edge of the clock
      r_write_data <= r_write_data + 1; -- write a number 1 bigger than the last
      r_write_address <= r_write_address + 1;   -- move to the next memory address
    end loop;

    -- Read out the incrementing pattern
    r_write_address  <= (others => '0');    -- reset the write address to 00
    r_write_data_valid <= '0';  -- signal to stop writing
    
    for i in 0 to DEPTH-1 loop  -- loop through each memory address again
      r_read_enable <= '1'; -- signal to read
      wait until r_clk = '1';   -- wait until the next rising edge of the clock
      r_read_address <= r_read_address + 1; -- move to the next memory address
    end loop;

    r_read_enable <= '0';   -- signal to stop reading
    wait until r_clk = '1'; -- wait until the 3rd rising edge of the clock from now
    wait until r_clk = '1';
    wait until r_clk = '1';

    -- Test reading and writing at the same time
    r_write_address <= "01";
    r_write_data <= X"84";  -- write 0x84 (10000100) to memory address 01
    r_read_address <= "01";
    r_read_enable <= '1';   -- simultaneously, read what is in memory address 01
    r_write_data_valid <= '1';  -- signal to write
    wait until r_clk = '1'; -- wait until the next rising edge of the clock
    r_read_enable <= '0';
    r_write_data_valid <= '0';  -- signal to stop reading and writing
    wait until r_clk = '1';
    wait until r_clk = '1';
    wait until r_clk = '1'; -- wait until the 3rd rising edge of the clock from now
    r_read_enable <= '1';   -- signal to read
    wait until r_clk = '1'; -- wait until the next rising edge of the clock
    r_read_enable <= '0';   -- signal to stop reading
    wait until r_clk = '1';
    wait until r_clk = '1';
    wait until r_clk = '1'; -- wait until the 3rd rising edge of the clock from now

    finish;
  end process;
  
end test;
