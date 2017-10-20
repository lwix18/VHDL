library IEEE;
use IEEE.std_logic_1164.all;

entity multiplexer is 
	port ( clk : in std_logic;
	       enable : in std_logic_vector(1 downto 0);
	       input : in std_logic_vector(2 downto 0);
	       reset : in std_logic;
	       output : out std_logic
	      );
end entity multiplexer;

library IEEE;
use IEEE.std_logic_1164.all;

architecture behavioral_multiplexer of multiplexer is
signal A,B,C : std_logic;
begin
process(clk, enable, reset, input)
begin
A <= input(0);
B <= input(1);
C <= input(2);
if(rising_edge(clk)) then
	if( reset = '1') then
		output <= '0';
	else
		case enable is
			when "00" => output <= A and B and C;
			when "01" => output <= A xor B xor C;
			when "10" => output <= A and (not B and not C);
			when "11" => output <= not C;
			when others => output <= '0';
		end case;
	end if;
end if;
end process;
end architecture behavioral_multiplexer;

	
	     
