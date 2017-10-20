library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
port(	A : in std_logic_vector(3 downto 0);
	B : in std_logic_vector(3 downto 0);
	M : in std_logic;
	S : in std_logic_vector(1 downto 0);
	C : in std_logic;
	clk : in std_logic;
	F : out std_logic_vector(4 downto 0)
     );
end entity ALU;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture behavioral_ALU of ALU is
begin
process(A, B, clk, M, S, C)
begin
if (rising_edge(clk)) then
	if (M = '0') then
		case S is
            		when "00" => F <= A;
			when "01" => F <= not A;
			when "10" => F <= A xor B;
			when "11" => F <= A xnor B;
		end case;
	else
		case S is
			when "00" => F <= std_logic_vector(resize(unsigned(A) + C),5));
			when "01" => F <= std_logic_vector(resize(C - unsigned(A)),5));
			when "10" => F <= std_logic_vector(resize((unsigned(B)- unsigned(A) + C),5));
			when "11" => F <= std_logic_vector(resize(unsigned(B) - unsigned(A) + C),5));
		end case;
	end if;
end process;
			
		


