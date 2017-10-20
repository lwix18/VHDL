
library IEEE;
use IEEE.std_logic_1164.all;

entity systeem is
port ( x, clk, reset : in std_logic;
      Y : out std_logic_vector(2 downto 0));
end systeem;

library IEEE;
use IEEE.std_logic_1164.all;

entity d_ff is
      port (d, clk, reset : in std_logic; q : out std_logic);
end d_ff;

architecture gedrag_dff of d_ff is
begin
      ff_behavior : process is
        begin
          wait until (clk'event and clk='1');
            if (reset = '1') then
              q <= '0';
            else
              q <= d;
            end if;
          end process;
end gedrag_dff;

library IEEE;
use IEEE.std_logic_1164.all;

entity nand2 is
        port (a, b : in std_logic; z : out std_logic);
end nand2;

architecture gedrag_nand2 of nand2 is
begin
      z <= a nand b;
end gedrag_nand2;

library IEEE;
use IEEE.std_logic_1164.all;

entity nand4 is
port (a, b, c, d : in std_logic; z : out std_logic);
end nand4;

architecture gedrag_nand4 of nand4 is
begin
z <= not (a and b and c and d);
end gedrag_nand4;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity systeem is
  port ( x, clk, reset : std_logic;
          Y : out std_logic_vector(2 downto 0));
end systeem;
       
architecture structural of systeem is 
  component nand2 is
    port (a, b : in std_logic; z : out std_logic);
  end component nand2;
  component nand4 is
    port (a, b, c, d : in std_logic; z : out std_logic);
  end component nand4;
  component d_ff is
    port (d,clk,reset: in std_logic; q : out std_logic);
  end component d_ff;

signal YK,YN,YL : std_logic_vector(2 downto 0);
signal xinv : std_logic;
signal s1a,s1b,s1c,s1d : STD_LOGIC;
signal s2a, s2b, s2c : STD_LOGIC;
signal s3a, s3b, s3c, s3d, s3e : STD_LOGIC;

BEGIN

L1: nand2 port map (a=> YK(2), b=> '1', z=> YN(2));
L2: nand2 port map (a=> YK(1), b=> '1', z=> YN(1));
L3: nand2 port map (a=> YK(0), b=> '1', z=> YN(0));
L4: nand2 port map (a=> x, b=> '1', z=> xinv);

L5: nand2 port map (a=> YN(2), b=> x, z=> s1c);
L6: nand2 port map (a=> YN(1), b=> x, z=> s1d);
L7: nand2 port map (a=> s1c, b=> s1d, z=> YL(1));

L8: nand4 port map (a=> YK(2), b=> YK(1), c=> x, d=> '1', z=> s2a);
L9: nand2 port map (a=> YK(0), b=> xinv, z=> s2b);
L10: nand2 port map (a=> s2a, b => s2b, z=> YL(0));

L11: nand2 port map (a=> YN(2), b=> YK(1), z=> s3a);
L12: nand2 port map (a=> YK(1), b=> x, z=> s3b);
L13: nand2 port map (a=> YK(2), b=> YN(1), z=> s3c);
L14: nand4 port map (a=> s3a, b=> s3b, c=> s3c, d=> '1', z=> YL(2));
 
Y(2) <= YK(2);
Y(1) <= YK(1);
Y(0) <= YK(0);

L15: d_ff port map (d=> YL(2), clk=> clk, reset=> reset, q=> YK(2));
L16: d_ff port map (d=> YL(1), clk=> clk, reset=> reset, q=> YK(1));
L17: d_ff port map (d=> YL(0), clk=> clk, reset=> reset, q=> YK(0));

END structural;