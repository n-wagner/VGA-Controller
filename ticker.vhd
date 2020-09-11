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
			-- 50 MHz in or 50 million ticks per second
			-- 10 Hz or 10 ticks per second out (counter is for half a tick)
			if (counter = 2500000) then
				reg <= NOT reg;
				counter <= 1;
			end if;
		end if;
		tick <= reg;
	end process;
end main;