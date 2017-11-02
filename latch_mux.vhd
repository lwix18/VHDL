library ieee;
use ieee.std_logic_1164.all;

entity latch_mux is
port( 
      D1 : in std_logic;
      Q1 : out std_logic;
      clk : in std_logic
);
end entity latch_mux;

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

entity not_gate is
port ( a : in std_logic; b : out std_logic);
end entity not_gate;

architecture behav_not_gate of not_gate is
begin
	b <= not a;
end architecture behav_not_gate;
 
library ieee;
use ieee.std_logic_1164.all;

entity latch_mux is
port( D1 : in std_logic;
      Q1 : out std_logic;
      clk : in std_logic
);
end entity latch_mux;

architecture structural of latch_mux is

component not_gate is
port (a : in std_logic; b : out std_logic);
end component;

component reg_mux is
port (D, S, clk : in std_logic; Q : out std_logic);
end component;

signal Qtemp, Qk, Qs : std_logic;

begin

L1: reg_mux port map ( D => D1, S => Qtemp, clk => clk, Q => Qk);
L2: not_gate port map (a => Qk, b => Qs);
L3: not_gate port map (a => Qs, b => Qtemp);

Q1 <= Qtemp;

end structural;

