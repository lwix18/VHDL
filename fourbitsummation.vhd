library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is 
	port ( A0 : in std_logic_vector(3 downto 0);
	       B0 : in std_logic_vector(3 downto 0);
	       C_in : in std_logic;
	       clk : in std_logic;
	       S : out std_logic_vector(3 downto 0);
	       C_out : out std_logic
	      );
end entity adder;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity four_bit is
	port ( A : in std_logic;
	       B : in std_logic;
	       clk : in std_logic;
	       c_in : in std_logic;
	       S : out std_logic;
	       c_out : out std_logic
	     );
end entity four_bit;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture behav_four_bit of four_bit is
begin
process(clk,A,B,c_in)
begin
	if(rising_edge(clk)) then
		S <= A xor B xor c_in;
		c_out <= (A and B) or ((A or B) and c_in);
	end if;
end process;
end architecture behav_four_bit;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture structural of adder is
component four_bit is
	port ( A : in std_logic;
	       B : in std_logic;
	       clk : in std_logic;
	       c_in : in std_logic;
	       S : out std_logic;
	       c_out : out std_logic
	     );
end component four_bit;

signal c1, c2, c3 : std_logic;

begin

L1: four_bit port map (A0(0), B0(0), clk, c_in, S(0), c1);
L2: four_bit port map (A0(1), B0(1), clk, c1, S(1), c2);
L3: four_bit port map (A0(2), B0(2), clk, c2, S(2), c3);
L4: four_bit port map (A0(3), B0(3), clk, c3, S(3), c_out);

end structural;

