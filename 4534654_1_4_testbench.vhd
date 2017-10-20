library IEEE;
use IEEE.std_logic_1164.ALL;

entity systeem_testbench is
end entity systeem_testbench;

architecture gedrag of systeem_testbench is
   component systeem
      port (clk   : in std_logic;
            reset : in std_logic;
            x     : in std_logic;
            Y     : out std_logic_vector(2 downto 0));
   end component;

   signal clk, reset, x : std_logic;
   signal Y : std_logic_vector(2 downto 0);

begin 

   L1: systeem port map (clk, reset, x, Y);
   
   clk <= '0' after 0 ns,
          '1' after 5 ns  when clk /= '1' else '0' after 5 ns;

   reset <= '1' after  0 ns,
            '0' after 20 ns;

   x <= '0' after 0 ns,
        '1' after 30 ns,
        '0' after 40 ns,
	'1' after 60 ns,
	'0' after 80 ns,
	'1' after 90 ns,
	'0' after 100 ns,
	'1' after 110 ns,
	'0' after 160 ns;

end architecture gedrag;
