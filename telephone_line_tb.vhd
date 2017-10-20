library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity telephone_line_tb is
end entity telephone_line_tb;

architecture behaviour_telephone_line_tb of telephone_line_tb is
component telephone_line

port
(	a_busy : in std_logic;
	b_busy : in std_logic;
	push : in std_logic;
	clk : in std_logic;
	a_relay : out std_logic;
	b_relay : out std_logic
);
end component;

signal clk, a_busy, b_busy, push, a_relay, b_relay : std_logic;

begin

	lb11: telephone_line port map (a_busy, b_busy, push, clk, a_relay, b_relay);

	clk <= '0' after 0 ns,
	   	'1' after  10 ns  when clk /= '1' else '0' after 10 ns;
	push <= '1' after 0 ns,
		'0' after 20 ns,
		'1' after 200 ns;
	a_busy <= '0' after 0 ns,
		  '1' after 20 ns,
		  '0' after 60 ns,
		  '1' after 100 ns,
		  '0' after 140 ns,
		  '1' after 180 ns;
	b_busy <= '1' after 0 ns,
		  '0' after 40 ns,
		  '1' after 50 ns,
		  '0' after 70 ns,
		  '1' after 100 ns,
		  '0' after 120 ns,
		  '1' after 160 ns;

end architecture behaviour_telephone_line_tb;


	
	
