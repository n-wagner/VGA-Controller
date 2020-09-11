library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY VGA IS
	PORT(
		clk : in std_logic;  -- 50 MHz
		switch1 : in std_logic;
		switch2 : in std_logic;
		switch3 : in std_logic;
		CLOCK_24				: 	IN STD_LOGIC_VECTOR(1 downto 0);  --What is this?
		VGA_RESET			:	IN STD_LOGIC;
		VGA_HS,VGA_VS		:	OUT STD_LOGIC;
		VGA_R,VGA_B,VGA_G	: 	OUT STD_LOGIC_VECTOR(7 downto 0);
		VGA_CLK				: 	out std_logic
		);
END VGA;


ARCHITECTURE MAIN OF VGA IS
	SIGNAL VGACLK : STD_LOGIC;
	signal tick_counter : std_logic;

	COMPONENT SYNC IS
		PORT(
			CLK: IN STD_LOGIC;
			RST: IN STD_LOGIC;
			tick_counter : in std_logic;
			switch1 : in std_logic;
			switch2 : in std_logic;
			switch3 : in std_logic;
			HSYNC: OUT STD_LOGIC;
			VSYNC: OUT STD_LOGIC;
			R: OUT STD_LOGIC_VECTOR(7 downto 0);
			G: OUT STD_LOGIC_VECTOR(7 downto 0);
			B: OUT STD_LOGIC_VECTOR(7 downto 0)

		);
	END COMPONENT SYNC;

	component pll is
		port (
			clk_in_clk  : in  std_logic := 'X'; -- clk
			reset_reset : in  std_logic := 'X'; -- reset
			clk_out_clk : out std_logic         -- clk
		);
	end component pll;

	component ticker is
		port (
			clk: in std_logic;
			reset : in std_logic;
			tick : out std_logic
		);
	end component ticker;
BEGIN
 
	C: pll PORT MAP (CLOCK_24(0),VGA_RESET,VGACLK);
	C1: SYNC PORT MAP(VGACLK, tick_counter, switch1, switch2, switch3, VGA_RESET,VGA_HS,VGA_VS,VGA_R,VGA_G,VGA_B);
	t: ticker PORT MAP (clk, VGA_RESET, tick_counter);

	VGA_CLK <= VGACLK;

END MAIN;
