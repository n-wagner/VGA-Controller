library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my.all;

ENTITY SYNC IS
	PORT(
		CLK	: IN STD_LOGIC;
		RST	: in STD_LOGIC;
		tick_counter : in std_logic;
		switch1 : in std_logic;
		switch2 : in std_logic;
		switch3 : in std_logic;
		HSYNC	: OUT STD_LOGIC;
		VSYNC	: OUT STD_LOGIC;
		R		: OUT STD_LOGIC_VECTOR(7 downto 0);
		G		: OUT STD_LOGIC_VECTOR(7 downto 0);
		B		: OUT STD_LOGIC_VECTOR(7 downto 0)

	);
END SYNC;


ARCHITECTURE MAIN OF SYNC IS
	--SIGNAL RGB	: STD_LOGIC_VECTOR(3 downto 0);
	--SIGNAL square1_x_axis,square1_y_axis: INTEGER RANGE 0 TO 1687:=0;
	--SIGNAL square2_x_axis,square2_y_axis: INTEGER RANGE 0 TO 1687:=0;
	SIGNAL draw 	: STD_LOGIC;
	signal square1_xpos: integer:=0;
	signal square2_xpos: integer:=0;
	signal square1_ypos: integer:=0;
	signal square2_ypos: integer:=0;
	SIGNAL HPOS	: INTEGER RANGE 0 TO 1687:=0;
	SIGNAL VPOS	: INTEGER RANGE 0 TO 1065:=0;
	type states is (disp, no_disp, h_sp, v_sp, both_sp);
	signal state_reg  : 	states;
	
BEGIN
	--square(HPOS,VPOS,square1_x_axis,square1_y_axis,RGB);
	--square(HPOS,VPOS,square2_x_axis,square2_y_axis,RGB);
	
	--updates square position based on ticks
	--ticks should be less than frames per second (60 Hz = 60 fps => ticks < 60 Hz)
	
	--I think this should just use the same 108MHz clock or the timing will get confusing
	--let's start the squares off in different vertical spots so they don't overlap
	--this only gets called every half of a second, need to figure out how fast to move it
	--on every other call (due to tick_counter)
	--need x and y pos for both squares
	update_square_pos: process (tick_counter, rst)
	begin
		if (rst = '1') then
			square1_xpos <= 0;
			square1_ypos <= 0;
			square2_xpos <= 0;
			square2_ypos <= 512;
		elsif rising_edge(tick_counter) then
			--Each tick updates the respective position if the switch is on
			--Position capped at horizontal edge of screen - size of box
			if (switch1 = '1') then
				square1_xpos <= square1_xpos + 1;
				if (square1_xpos > 1279 - 100) then
					square1_xpos <= 0;
				end if;
			end if;
			if (switch2 = '1') then
				square2_xpos <= square2_xpos + 1;
				if (square2_xpos > 1279 - 100) then
					square2_xpos <= 0;
				end if;
			end if;
		end if;
	end process;
	
	update_pos: process(clk, rst)
	begin
		if (rst = '1') then
			hpos <= 1687;
			vpos <= 1065;
		elsif rising_edge(clk) then
		
			--increment position
			if (hpos = 1687) then
				hpos <= 0;
				if (vpos = 1065) then
					vpos <= 0;
				else
					vpos <= vpos + 1;
				end if;
			else
				hpos <= hpos + 1;
			end if;

		end if;
		
	end process;
	
	state_selection : process(hpos, vpos)
	begin
		if ((hpos < 1280) AND (vpos < 1024)) then
			state_reg <= disp;	--active region
		else
			if (((hpos > 1327) AND (hpos < 1440)) AND ((vpos > 1024) AND (vpos < 1028))) then
				state_reg <= both_sp;	--both h and v in SP region
			elsif (((hpos < 1328) OR (hpos > 1439)) AND ((vpos > 1024) AND (vpos < 1028))) then
				state_reg <= v_sp;  --h inactive but not in SP region, v inactive and in SP region
			elsif (((hpos > 1327) AND (hpos < 1440)) AND ((vpos < 1025) OR (vpos > 1027))) then
				state_reg <= h_sp;  --h inactive and in SP region, v inactive but not in SP region
			else
				state_reg <= no_disp;
			end if;
		end if;
	end process;
	
	--given current pixel coordinates and draw signal will determine the RGB values
	drawing: process(hpos, vpos, draw)
	begin
		if (draw = '1') then
			if ((hpos >= (square1_xpos)) AND (hpos < (square1_xpos + 100)) AND (vpos >= square1_ypos) AND (vpos < square1_ypos + 100)) then
				--sw3 controls color (makes square1 blue) otherwise it is red_green
				if (switch3 = '1') then
					B <= "11111111";
					R <= "00000000";
					G <= "00000000";
				else
					R <= "11111111";
					G <= "11111111";
					B <= "00000000";
				end if;
			elsif ((hpos >= (square2_xpos)) AND (hpos < (square2_xpos + 100)) AND (vpos >= square2_ypos) AND (vpos < square2_ypos + 100)) then
				R <= "11111111";
				G <= "11111111";
				B <= "00000000";
			else
				R <= "00000000";
				G <= "00000000";
				B <= "00000000";
			end if;
		else
			R <= "00000000";
			G <= "00000000";
			B <= "00000000";
		end if;
	end process;

	--draw = '1' => in draw region
	set_ctrl_sigs : process(state_reg)
	begin
		case state_reg is
			when disp =>
				draw <= '1';
				hsync <= '1';
				vsync <= '1';
			when no_disp =>
				draw <= '0';
				hsync <= '1';
				vsync <= '1';
			when h_sp =>
				draw <= '0';
				hsync <= '0';
				vsync <= '1';
			when v_sp =>
				draw <= '0';
				hsync <= '1';
				vsync <= '0';
			when both_sp =>
				draw <= '0';
				hsync <= '0';
				vsync <= '0';
			when others =>
				draw <= '0';
				hsync <= '1';
				vsync <= '1';
		end case;
	end process;
	
	
END MAIN;