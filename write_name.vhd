library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_name is
	port (
		clk		 :	in std_logic;
		up			 :	in std_logic;
		down		 :	in	std_logic;
		set		 :	in	std_logic;
		rw, rs, e : out std_logic;  --read/write, setup/data, and enable for lcd 
		lcd_data  : out std_logic_vector(7 downto 0)  --data signals for lcd
	);
end entity;

architecture rtl of write_name is
	variable char : integer range 0 to 25 := 0;
	signal lcd_enable : std_logic;
	signal lcd_bus		: std_logic_vector(9 downto 0);
	signal lcd_busy	: std_logic;
	constant A : integer := 577;
	component lcd_controller is
		port (
			clk			:	in std_logic;
			reset_n		:	in std_logic;
			lcd_enable	:	in std_logic;
			lcd_bus		:	in std_logic_vector(9 downto 0);
			busy			:	out std_logic;
			rw, rs, e	:	out std_logic;
			lcd_data		:	out std_logic_vector(7 downto 0)
		);
	end component;
	
	-- Build an enumerated type for the state machine
	type state_type is (S0, s1, s2, s3);

	-- Register to hold the current state
	signal state   : state_type;

begin
	control: lcd_controller
		port map (clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, 
					busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
		
	process(up, down)
	begin
		if(up'event and up='1') then
			char := char + 1;
		elsif(down'event and down='1') then
			char := char - 1;
		end if;
	end process;	

	process (clk)
		begin
			if(clk'event and clk='1') then
				case state is
					when s0=>
						if(lcd_busy='0' and lcd_enable='0') then
							state <= s1;
						else
							state <= s0;
						end if;
					when s1=>
						if ((up'event and up='1') or (down'event and down='1')) then
							state <= s2;
						elsif (set'event and set='1') then
							state <= s3;
						end if;
					when s2=>
						state <= s3;
					when s3 =>
						state <= s1;
				end case;
			end if;
		end process;
		
		process(state)
		begin
			case state is
				when s0=>
					lcd_enable <= '0';
					lcd_bus <= "0000000000";
				when s1 =>
					lcd_enable <= '0';
					lcd_bus <= "0000000000";
				when s2 =>
					lcd_enable <= '1';
					lcd_bus <= "0000010000";
				when s3 =>
					lcd_enable <= '1';
					lcd_bus <= std_logic_vector(to_unsigned(char + A, 10));
			end case;
		end process;				
			
end architecture;
	

		
			
				
				
