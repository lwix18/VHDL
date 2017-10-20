library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity telephone_line is
	port(	a_busy : in std_logic;
		b_busy : in std_logic;
		push : in std_logic;
		clk : in std_logic;
		a_relay : out std_logic;
		b_relay : out std_logic
	    );
end entity telephone_line;

--------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture behaviour_telephone_line of telephone_line is

type telephone_state is (a_state, b_state, pa_state, rp_state);
signal state, new_state : telephone_state;
signal busy : std_logic_vector(2 downto 0);

begin

busy(0) <= a_busy;
busy(1) <= b_busy;
busy(2) <= push;


registerclk : process(clk,busy(2))
		begin
			if(clk'event and clk = '1') then
				if(busy(2) = '1') then
					state <= rp_state;
				else
					state <= new_state;
				end if;
			end if;
	   end process;

telephoneline : process(state,busy)
begin
	case state is
		when rp_state =>
			case busy is
				when "001" => new_state <= a_state;
				when "010" => new_state <= b_state;
				when "011" => new_state <= pa_state;
				when others => 	new_state <= rp_state;
			end case;
			a_relay <= '1';
			b_relay <= '1';
		when a_state =>
			a_relay <= '1';
			b_relay <= '0';
			case busy is
				when "1--" => new_state <= rp_state;
				when "010" => new_state <= rp_state;
				when "000" => new_state <= rp_state;
				when "011" => new_state <= a_state;
				when others => new_state <= a_state;
			end case;
		when b_state =>
			a_relay <= '0';
			b_relay <= '1';
			case busy is
				when "1--" => new_state <= rp_state;
				when "001" => new_state <= rp_state;
				when "000" => new_state <= rp_state;
				when "010" => new_state <= b_state;
				when "011" => new_state <= b_state;
				when others => new_state <= b_state;
			end case;
		when pa_state =>
			a_relay <= '1';
			b_relay <= '0';
			case busy is
				when "1--" => new_state <= rp_state;
				when "000" => new_state <= rp_state;
				when "010" => new_state <= rp_state;
				when others => new_state <= pa_state;
			end case;
	end case;
end process;

end architecture behaviour_telephone_line;	 



