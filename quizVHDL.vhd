library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity quizVHDL is
	port (
		clk		: in std_logic;
		button : in std_logic_vector(3 downto 0);
		rw, rs, e : out std_logic;
		lcd_data : out std_logic_vector(7 downto 0);
		--FLASH
		CE  : out std_logic;
		OE  : out std_logic;
		address_memory : out std_logic_vector(22 downto 0);
		flash_data : in std_logic_vector(7 downto 0);
		--DEBUG
		deb_start : out std_logic;
		deb_turno : out std_logic;
		deb_b_edge : out std_logic_vector(3 downto 0);
		deb_acertos: out std_logic_vector(2 downto 0);
		state : out std_logic_vector(2 downto 0)
		);
end entity;

architecture rtl of quizVHDL is
	signal lcd_enable : std_logic;
	signal lcd_bus    : std_logic_Vector(9 downto 0);
	signal lcd_busy   : std_logic;
	-- Buttons
	signal b_deb		: std_logic_vector(3 downto 0);
	signal b_edge		: std_logic_vector(3 downto 0);
	-- Write questions
	signal rfrw, rfrs, rfe : std_logic;
	signal rflcd_data      : std_logic_Vector(7 downto 0);
	signal fim_turno 		  : std_logic;
	signal gabarito	  	  : std_logic_vector(3 downto 0);
	signal rfrst		     : std_logic;
	-- Turno
	signal acerto		  : std_logic;
	signal start		  : std_logic;
	signal tfim_turno   : std_logic;
	signal tempo		  : integer range 0 to 30;
	-- Integracao
	signal no_acertos	  : std_logic_vector(2 downto 0);
	
	type state_type is (init, Q1, Q2, Q3, Q4, Q5, ranking);
	signal ss : state_type;
	
begin
--	dut: entity work.lcd_controller
--		port map(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, 
--					busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
--	
	deb_b0: entity work.debounce
		port map (clk => clk, button => button(0), result => b_deb(0));
	deb_b1: entity work.debounce
		port map (clk => clk, button => button(1), result => b_deb(1));
	deb_b2: entity work.debounce
		port map (clk => clk, button => button(2), result => b_deb(2));
	deb_b3: entity work.debounce
		port map (clk => clk, button => button(3), result => b_deb(3));
	
	edge_b0: entity work.edge_detector 
		port map (clk => clk, signal_in => not(b_deb(0)), output => b_edge(0));
	edge_b1: entity work.edge_detector 
		port map (clk => clk, signal_in => not(b_deb(1)), output => b_edge(1));
	edge_b2: entity work.edge_detector 
		port map (clk => clk, signal_in => not(b_deb(2)), output => b_edge(2));
	edge_b3: entity work.edge_detector
		port map (clk => clk, signal_in => not(b_deb(3)), output => b_edge(3));
	
	write_question: entity work.read_flash
		port map(clk => clk, reset => rfrst, turno => fim_turno, gabarito => gabarito,
					rw => rfrw, rs => rfrs, e => rfe, lcd_data => rflcd_data,
					CE => CE, OE => OE, address_memory => address_memory, data => flash_data);
	jogada: entity work.turno
		port map(clk => clk, button_edge => b_edge, gabarito => gabarito, fim_turno => tfim_turno,
		acerto => acerto, start => start, tempo => tempo);
		
	process(ss)
	begin
		case ss is
			when init =>
				rw <= rfrw;
				rs <= rfrs;
				e 	<= rfe;
				lcd_data <= rflcd_data;
				
				fim_turno <= b_edge(0) or b_edge(1) or b_edge(2) or b_edge(3);
				state <= "000";
			when Q1 =>
				rw <= rfrw;
				rs <= rfrs;
				e 	<= rfe;
				lcd_data <= rflcd_data;
				
				fim_turno <= tfim_turno;
				state <= "001";
			when Q2 =>
				rw <= rfrw;
				rs <= rfrs;
				e 	<= rfe;
				lcd_data <= rflcd_data;
				
				fim_turno <= tfim_turno;
				state <= "010";
			when Q3 =>
				rw <= rfrw;
				rs <= rfrs;
				e 	<= rfe;
				lcd_data <= rflcd_data;
				
				fim_turno <= tfim_turno;
				
				state <= "011";
			when Q4 =>
				rw <= rfrw;
				rs <= rfrs;
				e 	<= rfe;
				lcd_data <= rflcd_data;
				
				fim_turno <= tfim_turno;
				
				state <= "100";
			when Q5 =>
				rw <= rfrw;
				rs <= rfrs;
				e 	<= rfe;
				lcd_data <= rflcd_data;
				
				fim_turno <= tfim_turno;
				
				state <= "101";
			when ranking =>
				state <= "110";
		end case;
	end process;
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			case ss is
				when init =>
					if ((b_edge /= "0000") and (b_edge /= "1111")) then
						start <= '1';
						ss <= Q1;
					else
						start <= '0';
						ss <= init;
					end if;
				when Q1 =>
					if (fim_turno ='1')  then
						start <= '1';
						ss <= Q2;
					else
						start <= '0';
						ss <= Q1;
					end if;
				when Q2 =>
					if (fim_turno ='1')  then
						start <= '1';
						ss <= Q3;
					else
						start <= '0';
						ss <= Q2;
					end if;
				when Q3 =>
					if (fim_turno ='1')  then
						start <= '1';
						ss <= Q4;
					else
						start <= '0';
						ss <= Q3;
					end if;
				when Q4 =>
					if (fim_turno ='1')  then
						start <= '1';
						ss <= Q5;
					else
						start <= '0';
						ss <= Q4;
					end if;
				when Q5 =>
					if (fim_turno ='1')  then
						ss <= ranking;
					else
						start <= '0';
						ss <= Q5;
					end if;
				when ranking =>
					if (b_edge(0) = '1') then
						ss <= init;
					end if;
			end case;
		end if;
		
		if(acerto = '1') then
			no_acertos <= no_acertos + '1';
		end if;
	end process;
	
	deb_start <= start;
	deb_turno <= fim_turno;
	deb_b_edge <= b_edge;
	deb_acertos <= no_acertos;
end architecture;