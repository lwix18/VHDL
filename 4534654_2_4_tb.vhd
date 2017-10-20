-- student: Lynrick Wix
-- 	studienummer: 4534654


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity encoder_tb is
end entity encoder_tb;

architecture behaviour of encoder_tb is
component  encoder 

PORT
(
        clk:     IN std_logic;                         -- clock
        reset:   IN std_logic;                         -- async reset
        start:   IN std_logic;                         -- start signal
        x:       IN std_logic_vector (7 DOWNTO 0);     -- input
        y:       OUT std_logic_vector (7 DOWNTO 0);    -- output
        ready:   OUT std_logic                         -- ready signal
);
END component;
 	

 signal clk,reset,ready,start : std_logic; 
 signal x,y: std_logic_vector(7 downto 0);
 
begin 
 
   lbl1: encoder port map (clk, reset, start, x,y,ready);
   
   clk <= '0' after 0 ns,
	   '1' after  10 ns  when clk /= '1' else '0' after 10 ns;

   reset <= '1' after  0 ns,
            '0' after 20 ns,
	    '1' after 150 ns,
	    '0' after 170 ns,
	    '1' after 400 ns,
 	    '0' after 420 ns;

  start <=	 '0' after 0 ns,
		 '1' after 20 ns,
		 '0' after 40 ns,
		 '1' after 150 ns,
		 '0' after 170 ns,
		 '1' after 400 ns,
		 '0' after 420 ns;
	
x <= "00000000"	after 0 ns,
     "10101101" after 150 ns,
     "01100101" after 400 ns;

   

	    
end architecture behaviour;



