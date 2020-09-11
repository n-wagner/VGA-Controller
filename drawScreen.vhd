library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY drawScreen IS
	PORT(
		HPOS: IN INTEGER RANGE 0 TO 1687;
		VPOS: IN INTEGER RANGE 0 TO 1065;
		R: OUT STD_LOGIC_VECTOR(7 downto 0);
		G: OUT STD_LOGIC_VECTOR(7 downto 0);
		B: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END drawScreen;


ARCHITECTURE MAIN OF drawScreen IS
BEGIN
	R <= "11111111";
	G <= "11111111";
	B <= "11111111";
END MAIN;