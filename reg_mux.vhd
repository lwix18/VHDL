library ieee;
use ieee.std_logic_1164.all;

entity reg_mux is
port (
	D : in std_logic;
	S : in std_logic;
	Q : out std_logic;
	clk : in std_logic
);
end entity reg_mux;

library ieee;
use ieee.std_logic_1164.all;

architecture behav_reg_mux of reg_mux is 
begin

process(D,S,clk)
begin
	if(rising_edge(clk)) then
		Q <= S;
	else
		Q <= D;
end if;
end process;

end architecture behav_reg_mux;
