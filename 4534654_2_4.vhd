
-------------------------------------------------------------------------------
--
-- Written by:
-- Arjan J.C. van Gemund
-- Arjan van Genderen
--
-- Faculty of Electrical Engineering Mathematics and Computer Science
-- Delft University of Technology
-- P.O. Box 5031
-- NL-2600 GA  Delft
-- The Netherlands
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--
-- Definition package
--
-- Constants, types, conversion functions, etc.
--
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE delta_defs IS

-- define array type for the 8-bit data paths to connect
-- the registers to their 3-state buffers:

TYPE std_logic_array IS
ARRAY (natural RANGE <>) OF std_logic_vector (7 DOWNTO 0);

-- define natural <-> std_logic conversion functions:

FUNCTION b2n(b: std_logic)
RETURN natural;

FUNCTION s2n(v: std_logic_vector)
RETURN natural;

FUNCTION n2s(n: natural; length: natural)
RETURN std_logic_vector;

END delta_defs;

PACKAGE BODY delta_defs IS

-------------------------------------------------------------------------------
-- convert std_logic bit b to natural
-------------------------------------------------------------------------------

FUNCTION b2n(b: std_logic)
RETURN natural IS
VARIABLE result: natural := 0;
BEGIN
        IF b = '1' THEN
                result := 1;
        END IF;
        RETURN result;
END b2n;

-------------------------------------------------------------------------------
-- convert std_logic vector v to natural
-------------------------------------------------------------------------------

FUNCTION s2n(v: std_logic_vector)
RETURN natural IS
VARIABLE result: natural := 0;
BEGIN
        FOR i IN v'range LOOP
                result := result * 2;
                IF v(i) = '1' THEN
                        result := result + 1;
                END IF;
        END LOOP;
        RETURN result;
END s2n;

-------------------------------------------------------------------------------
-- convert natural n to length-bit std_logic vector
-------------------------------------------------------------------------------

FUNCTION n2s(n: natural; length: natural)
RETURN std_logic_vector IS
VARIABLE result: std_logic_vector (length-1 DOWNTO 0);
VARIABLE copy: natural;
BEGIN
        copy := n;
        FOR i IN 0 TO length-1 LOOP
                IF copy MOD 2 = 1 THEN
                        result(i) := '1';
                ELSE
                        result(i) := '0';
                END IF;
                copy := copy / 2;
        END LOOP;
        RETURN result;
END n2s;

END delta_defs;



-------------------------------------------------------------------------------
-- 8-bit edge-triggered D register 
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY reg IS
PORT
(
        reg_clk:        IN std_logic;                           -- clock
        reg_d:          IN std_logic_vector (7 DOWNTO 0);       -- data in
        reg_q:          OUT std_logic_vector (7 DOWNTO 0)       -- data out
);
END reg;

ARCHITECTURE reg_arch OF reg IS
BEGIN
        PROCESS (reg_clk)
        BEGIN
                IF (reg_clk'event AND reg_clk = '1') THEN
                        reg_q <= reg_d;
                END IF;
        END PROCESS;
END reg_arch;

-------------------------------------------------------------------------------
-- 8-bit ALU with ADD, XOR, AND operations + C, Z flags
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.delta_defs.ALL;

ENTITY alu IS
PORT
(
        alu_clk:        IN std_logic;                           -- clock
        alu_op:         IN std_logic_vector (2 DOWNTO 0);       -- opcode
        alu_x0:         IN std_logic_vector (7 DOWNTO 0);       -- data0 in
        alu_x1:         IN std_logic_vector (7 DOWNTO 0);       -- data0 in
        alu_y:          OUT std_logic_vector (7 DOWNTO 0);      -- data out
        alu_c:          OUT std_logic                           -- C flag
);
END alu;

ARCHITECTURE alu_arch OF alu IS
SIGNAL o2,o1,o0,c:      std_logic;                              -- opcode + c
BEGIN

        -- alu_y arithmetic:

        WITH alu_op SELECT
        alu_y <=        alu_x0                  WHEN "000",     -- pass x0
                        alu_x1                  WHEN "111",     -- pass x1
                        "00000000"              WHEN "001",     -- set c
                        "00000000"              WHEN "010",     -- clr c
                        n2s(s2n(alu_x0) +
                            s2n(alu_x1) +
                            b2n(c),8)           WHEN "011",     -- add
                        alu_x0 XOR alu_x1       WHEN "100",     -- xor
                        alu_x0 AND alu_x1       WHEN "101",     -- and
                        "00000000" WHEN OTHERS;

        o2 <= alu_op(2);
        o1 <= alu_op(1);
        o0 <= alu_op(0);

        PROCESS (alu_clk)
        BEGIN
                IF (alu_clk'event AND alu_clk = '1') THEN

                        -- c condition:

                        IF    ((o2 = '0') AND (o1 = '1') AND (o0 = '0')) OR
                            ((o2 = '0') AND (o1 = '1') AND (o0 = '1') AND
                            (s2n(alu_x0)+s2n(alu_x1)+b2n(c) < 256)) THEN
                                        c <= '0';
                        ELSIF ((o2 = '0') AND (o1 = '0') AND (o0 = '1')) OR
                              ((o2 = '0') AND (o1 = '1') AND (o0 = '1') AND
                               (s2n(alu_x0)+s2n(alu_x1)+b2n(c) > 255)) THEN
                                        c <= '1';
                        END IF;

                END IF;

        END PROCESS;

        alu_c <= c;
END alu_arch;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity controller is

	port ( clk : in std_logic;	
	       reset : in std_logic;
	       start : in std_logic;
	       c : in std_logic;
	       alu_y_reg : in std_logic_vector(7 downto 0);
	       ready : out std_logic;
	       op : out std_logic_vector(2 downto 0)
	     );
end entity controller;

architecture behavioural_controller of controller is


type controller_state is (pass_x1_state, pass_x0_state, set_c_state,
			  add_one_state, xor_state, and_state, pass_x1_reset_state, add_two_state, add_three_state, pass_x1_two_state);

signal state, new_state : controller_state;

begin
process(clk)

begin 
	if (rising_edge(clk)) then
		if (reset = '1') then
			state <= pass_x1_reset_state;
		else
			state <= new_state;
		end if;
	end if;
end process;

process(c, alu_y_reg, start,state)
begin
	case state is
		when pass_x0_state =>
			op <= "000";
			ready <= '0';
			new_state <= add_one_state;

		when add_one_state =>
			op <= "011";
			ready <= '0';
			new_state <= pass_x1_state;

		when pass_x1_state =>
			op <= "111";
			ready <= '0';
			if (unsigned(alu_y_reg) <= 127) then
				 new_state <= add_two_state;
			else
				 new_state <= and_state;
			end if;

		when and_state =>
			op <= "101";
			ready <= '0';
			new_state <= xor_state;

		when xor_state =>
			op <= "100";
			ready <= '0';
			new_state <= add_three_state;

		when add_two_state =>
			op <= "011";
			ready <= '0';
			new_state <= pass_x1_two_state;

		when pass_x1_two_state =>
			op <= "111";
			ready <= '0';
			if(c = '1') then
				new_state <= add_three_state;
			else
				new_state <= xor_state;
			end if;
		
		when add_three_state =>
			op <= "011";
			ready <= '0';
			new_state <= pass_x1_reset_state;
		when pass_x1_reset_state =>
			op <= "111";
			ready <= '1';
			if (start = '1') then
				new_state <= set_c_state;
			end if;
		when set_c_state =>
			op <= "001";
			ready <= '0';
			new_state <= pass_x0_state;
	end case;
end process;

end architecture behavioural_controller;


-------------------------------------------------------------------------------
--
-- The encoder itself
--
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.delta_defs.ALL;

ENTITY encoder IS
PORT
(
        clk:     IN std_logic;                         -- clock
        reset:   IN std_logic;                         -- async reset
        start:   IN std_logic;                         -- start signal
        x:       IN std_logic_vector (7 DOWNTO 0);     -- input
        y:       OUT std_logic_vector (7 DOWNTO 0);    -- output
        ready:   OUT std_logic                         -- ready signal
);
END encoder;

ARCHITECTURE encoder_arch OF encoder IS

-- these are the component types we are going to use:

COMPONENT reg
PORT
(
        reg_clk:        IN std_logic;                           -- clock
        reg_d:          IN std_logic_vector (7 DOWNTO 0);       -- data in
        reg_q:          OUT std_logic_vector (7 DOWNTO 0)       -- data out
);
END COMPONENT;

COMPONENT alu
PORT
(
        alu_clk:        IN std_logic;                           -- clock
        alu_op:         IN std_logic_vector (2 DOWNTO 0);       -- opcode
        alu_x0:         IN std_logic_vector (7 DOWNTO 0);       -- data0 in
        alu_x1:         IN std_logic_vector (7 DOWNTO 0);       -- data0 in
        alu_y:          OUT std_logic_vector (7 DOWNTO 0);      -- data out
        alu_c:          OUT std_logic                           -- C flag
);
END COMPONENT;

component controller
port
(	       clk : in std_logic;	
	       reset : in std_logic;
	       start : in std_logic;
	       c : in std_logic;
	       alu_y_reg : in std_logic_vector(7 downto 0);
	       ready : out std_logic;
	       op : out std_logic_vector(2 downto 0)
);
end component;

-- these are the signals we will use:

SIGNAL  reg_in:   std_logic_vector (7 DOWNTO 0);     
SIGNAL  reg_out:  std_logic_vector (7 DOWNTO 0);           
SIGNAL  op:       std_logic_vector (2 DOWNTO 0);          
SIGNAL  c:        std_logic;                              

BEGIN

-- instantiate the components we will use:

lbl_alu:     alu     PORT MAP (
                                alu_clk => clk,
                                alu_op => op,
                                alu_x0 => x,
                                alu_x1 => reg_out,
                                alu_y => reg_in,
                                alu_c => c);

lbl_reg:     reg     PORT MAP (
                                reg_clk => clk,
                                reg_d => reg_in,
                                reg_q => reg_out);

lbl_con:     controller port map (clk => clk,
				  reset => reset,
				  start => start,
				  c => c,
				  alu_y_reg => reg_out,
				  ready => ready,
				  op => op);
				
y <= reg_out;

END encoder_arch;

