library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Decare a testbench.  Notice that the testbench does not have any
-- input or output ports.
entity TEST_SYNC is
end TEST_SYNC;

-- Describes the functionality of the tesbench.
architecture TEST of TEST_SYNC is 

	-- The object that we wish to test is declared as a component of 
	-- the test bench. Its functionality has already been described elsewhere.
	-- This simply describes what the object's inputs and outputs are, it
	-- does not actually create the object.
	Component sync 
		port(
			CLK	: IN STD_LOGIC;
			RST	: in STD_LOGIC;
			HSYNC	: OUT STD_LOGIC;
			VSYNC	: OUT STD_LOGIC;
			R		: OUT STD_LOGIC_VECTOR(7 downto 0);
			G		: OUT STD_LOGIC_VECTOR(7 downto 0);
			B		: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END component;

	-- Specifies which description of the adder you will use.
	for U1: sync use entity WORK.sync(main);

	-- Create a set of signals which will be associated with both the inputs
	-- and outputs of the component that we wish to test.
	signal s_CLK		: IN STD_LOGIC;
	signal s_RST		: in STD_LOGIC;
	signal s_HSYNC		: OUT STD_LOGIC;
	signal s_VSYNC		: OUT STD_LOGIC;
	signal s_R			: OUT STD_LOGIC_VECTOR(7 downto 0);
	signal s_G			: OUT STD_LOGIC_VECTOR(7 downto 0);
	signal s_B			: OUT STD_LOGIC_VECTOR(7 downto 0);


	-- This is where the testbench for the sync actually begins.	
	begin
	
	-- Create a sync in the testbench. 	
	-- The signals specified above are mapped to their appropriate
	-- roles in the sync which we have created.
	U1: sync port map (s_CLK, s_RST, s_HSYNC, s_VSYNC, s_R, s_G, s_B);
	
	-- The process is where the actual testing is done.
	process
	begin

		--A_s <= "0000";
		--B_s <= "0000";
		--CIN_s <= '0';
		--wait for 10ns;
		--assert ( SUM_s = "0000" ) report "Failed case 0000 + 0000 - SUM" severity error;
		--assert ( COUT_s = '0' ) report "Failed case 0000 + 0000 - COUT" severity error;
		--wait for 40ns;
		
	end process;
END TEST;