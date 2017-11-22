library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity quizVHDL is
	port (
		clk		: in std_logic;
		--radd		: in std_logic_vector(1 downto 0);
		--set	: in std_logic;
		--name	: in std_logic_vector(29 downto 0);
		--tempo : in std_logic_vector(7 downto 0);
		--data_out	: out std_logic_vector(59 downto 0);
		button : out std_logic_vector(3 downto 0);
		rw, rs, e : out std_logic;
		lcd_data : out std_logic_vector(7 downto 0)
		);
end entity;

architecture rtl of quizVHDL is
	type state is (init, select_question, check_answer, write_name, ranking1, ranking2);
	state ss;
	signal we			: std_logic;
	signal wadd			: std_logic_vector(1 downto 0);
	signal data_in		: std_logic_vector(59 downto 0);
	signal nwena, nwup, nwdown, nwsel, nwrstn, nwfinished : std_logic;
	signal lcreset_n, lclcd_enable, lcbusy: std_logic;
	signal nwlcd_bus, lclcd_bus : std_logic_vector(9 downto 0);
		
begin
	controller: entity work.lcd_controller port map (
		clk  => clk,
		reset_n => lcreset_n,
		lcd_enable => lclcd_enable,
		lcd_bus => lclcd_bus,
		busy => lcbusy,
		rw => rw,
		rs => rs,
		e => e,
		lcd_data => lcd_data
	);
	
	ram: entity work.ramking port map (
		clk => clk, 
		we => we, 
		wadd => wadd, 
		radd => radd, 
		data_in => data_in,
		data_out => data_out
	);
	
	ranks: entity work.ranking port map (
		clk => clk,
		set => set,
		name => name,
		tempo => tempo,
		clear => '0',
		data_ram => data_in,
		addr_ram => wadd,
		we_ram => we
	);
	
	name_writer: entity work.name_writer port map (
		up => nwup,
		down => nwdown,
		sel => nwsel,
		clk => clk,
		ena => nwena,
		rstn => nwrstn,
		finished => nwfinished;
		lcd_bus => nwlcd_bus
	);
	
	process(clk, rst)
	begin
		if (rst) then
		
		end if;
		if (rising_edge(clk)) then
			case ss is 
				when init =>
					if (lcd_busy = '0' and lcd_enable = '0') then
						ss <= select_question;
					else
						lcd_enable <= '0';
					end if;
				when select_question =>
				
				when check_answer =>
				
				when write_name =>
					nwena <= '1';
					nwup <= button[0];
					nwdown <= button[1];
					nwsel <= button[3];
					
					lclcd_bus <= nwlcd_bus;
					lclcd_enable <= nwlcd_enable;
					
					if (nwfinished = '1') then]
						ss <= ranking1;
					end if;
					
				when ranking1 =>
				
				when ranking2 =>
			end case;
		end if;
	end process;
end architecture;