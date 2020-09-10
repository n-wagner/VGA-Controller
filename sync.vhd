library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my.all;

ENTITY SYNC IS
	PORT(
		CLK	: IN STD_LOGIC;
		RST	: in STD_LOGIC;
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
	SIGNAL HPOS	: INTEGER RANGE 0 TO 1687:=0;
	SIGNAL VPOS	: INTEGER RANGE 0 TO 1065:=0;
	type states is (disp, no_disp, h_sp, v_sp, both_sp);
   signal state_reg  : 	states;
	
BEGIN
	--square(HPOS,VPOS,square1_x_axis,square1_y_axis,RGB);
	--square(HPOS,VPOS,square2_x_axis,square2_y_axis,RGB);
	
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
	
	set_ctrl_sigs : process(state_reg)
	begin
		case state_reg is
			when disp =>
				R <= "11111111";
				G <= "11111111";
				B <= "11111111";
				hsync <= '1';
				vsync <= '1';
			when no_disp =>
				R <= "00000000";
				G <= "00000000";
				B <= "00000000";
				hsync <= '1';
				vsync <= '1';
			when h_sp =>
				R <= "00000000";
				G <= "00000000";
				B <= "00000000";
				hsync <= '0';
				vsync <= '1';
			when v_sp =>
				R <= "00000000";
				G <= "00000000";
				B <= "00000000";
				hsync <= '1';
				vsync <= '0';
			when both_sp =>
				R <= "00000000";
				G <= "00000000";
				B <= "00000000";
				hsync <= '0';
				vsync <= '0';
			when others =>
				R <= "00000000";
				G <= "00000000";
				B <= "00000000";
				hsync <= '1';
				vsync <= '1';
		end case;
	end process;
	
	
END MAIN;