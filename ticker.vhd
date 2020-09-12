library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ticker is
	port (
		clk, reset: in std_logic;
		tick: out std_logic
	);
end ticker;

architecture main of ticker is

signal counter: integer := 1;
signal reg: std_logic := '0';

begin
	process (clk, reset)
	begin
		if (reset = '1') then
			counter <= 1;
			reg <= '0';
		elsif (clk'event AND clk = '1') then
			counter <= counter + 1;
			-- 108 MHz clock in from the PLL
			-- Want to be able to move 200 pixels per second with the switch
			-- So need 200 rising ticks per second
			-- To get 200 rising ticks per second, need 108M/400 = 270000
			if (counter = 270000) then
				reg <= NOT reg;
				counter <= 1;
			end if;
		end if;
		tick <= reg;
	end process;
end main;