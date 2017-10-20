library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity four_bit_tb is
end entity four_bit_tb;

architecture behaviour of four_bit_tb is
component adder
	port ( A0 : in std_logic_vector(3 downto 0);
	       B0 : in std_logic_vector(3 downto 0);
	       C_in : in std_logic;
	       clk : in std_logic;
	       S : out std_logic_vector(3 downto 0);
	       C_out : out std_logic
	     );
end component adder;

signal A0, B0, S : std_logic_vector(3 downto 0);
signal C_in, clk, C_out : std_logic;

begin

lb : adder port map (A0, B0, C_in, clk, S, C_out);

clk <= '0' after 0 ns,
	   '1' after  5 ns  when clk /= '1' else '0' after 5 ns;

A0 <= "0000" after 0 ns,
      "0101" after 40 ns,
      "0111" after 80 ns,
      "1000" after 120 ns,
      "0011" after 160 ns;

B0 <= "0000" after 0 ns,
      "0011" after 40 ns,
      "1000" after 80 ns,
      "0101" after 120 ns,
      "0001" after 160 ns;

C_in <= '0' after 0 ns;

end architecture behaviour;
