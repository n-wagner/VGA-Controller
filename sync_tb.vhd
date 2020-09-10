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
			RST	: IN STD_LOGIC;
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
	signal s_CLK		: STD_LOGIC;
	signal s_RST		: STD_LOGIC;
	signal s_HSYNC		: STD_LOGIC;
	signal s_VSYNC		: STD_LOGIC;
	signal s_R			: STD_LOGIC_VECTOR(7 downto 0);
	signal s_G			: STD_LOGIC_VECTOR(7 downto 0);
	signal s_B			: STD_LOGIC_VECTOR(7 downto 0);
	
	constant T : time := 10 ns; --corresponds to 100MHz,real clock will actually be 108


	-- This is where the testbench for the sync actually begins.	
	begin
	
	-- Create a sync in the testbench. 	
	-- The signals specified above are mapped to their appropriate
	-- roles in the sync which we have created.
	U1: sync port map (s_CLK, s_RST, s_HSYNC, s_VSYNC, s_R, s_G, s_B);
	
	--clock process
	clock:process 
	begin
		 s_clk <= '0';
		 wait for T/2;
		 s_clk <= '1';
		 wait for T/2;
	end process;
	
	-- The process is where the actual testing is done.
	force: process
	begin
	
		s_rst <= '1';
		wait for 20ns;
		s_rst <= '0';
		wait;
		--wait for 20 ns;
		
	end process;
END TEST;