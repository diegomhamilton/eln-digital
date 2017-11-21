library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity name_writer is
	port (
	up : in std_logic;
	down : in std_logic;
	sel : in std_logic;
	clk : in std_logic;
	ena : in	std_logic;
	rstn : in std_logic;
	rw, rs, e : out std_logic;
   lcd_data : out std_logic_vector(7 downto 0)
	);
end entity;
	
architecture behavior OF name_Writer is
	type state is (init, wait_key, back, send, full);
	signal lcd_enable : std_logic;
	signal lcd_bus    : std_logic_Vector(9 downto 0);
	signal lcd_busy   : std_logic;
	signal up_deb		: std_logic;
	signal down_deb	: std_logic;
	signal sel_deb		: std_logic;
	signal up_edge		: std_logic;
	signal down_edge	: std_logic;
	signal sel_edge	: std_logic;
	
	signal char : std_logic_vector(7 downto 0) := "01000001";
	signal ss : state;
	component lcd_controller is
		port(
			clk        : in  std_logic; --system clock
			reset_n    : in  std_logic; --active low reinitializes lcd
			lcd_enable : in  std_logic; --latches data into lcd controller
			lcd_bus    : in  std_logic_vector(9 downto 0); --data and control signals
			busy       : out std_logic; --lcd controller busy/idle feedback
			rw, rs, e  : out std_logic; --read/write, setup/data, and enable for lcd
			lcd_data   : out std_logic_vector(7 downto 0)); --data signals for lcd
	end component;
	
	component debounce is
		port(
			clk       : in  std_logic;
			button	: in  std_logic;
			result	: out std_logic
		);
	end component;
	
	component edge_detector is
		port(
			clk			: in  std_logic;
			signal_in	: in  std_logic; 
			output		: out std_logic
		);
	end component;
begin
	dut: lcd_controller
		port map(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, 
					busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
					
	deb_up: debounce port map (clk => clk, button => up, result => up_deb);
	deb_down: debounce port map (clk => clk, button => down, result => down_deb);
	deb_sel: debounce port map (clk => clk, button => sel, result => sel_deb);
	
	edge_up: edge_detector port map (clk => clk, signal_in => not(up_deb), output => up_edge);
	edge_down: edge_detector port map (clk => clk, signal_in => not(down_deb), output => down_edge);
	edge_sel: edge_detector port map (clk => clk, signal_in => not(sel_deb), output => sel_edge);
	
	process(clk)
		variable c_int : integer range 65 to 90;
		variable count : integer range 0 to 3;
	begin
		if (rstn = '0') then
			c_int := 65;
			count := 0;
			ss <= init;
		elsif (rising_edge(clk)) then
			case ss is
				when init =>
					if (lcd_busy = '0' and lcd_enable = '0') then
						ss <= send;
					else
						lcd_enable <= '0';
					end if;
				when wait_key =>
					lcd_enable <= '0';
					if (up_edge = '1') then
						if (c_int = 25 + 65) then
							c_int := 65;
						else
							c_int := c_int + 1;
						end if;
						ss <= back;
					elsif (down_edge = '1') then
						if (c_int = 65 + 0) then
							c_int := 25+65;
						else
							c_int := c_int - 1;
						end if;
						ss <= back;
					elsif(sel_edge = '1') then
						c_int := 65;
						count := count + 1;
						ss <= send;
					end if;
				when back =>
					if (lcd_busy = '0' and lcd_enable = '0') then
						lcd_enable <= '1';
						lcd_bus <= "00000100--";
						ss <= send;
					else
						lcd_enable <= '0';
					end if;
				when send =>
					if (count = 3) then
						ss <= full;
					elsif (lcd_busy = '0' and lcd_enable = '0') then
						lcd_enable <= '1';
						lcd_bus <= "10" & std_logic_vector(to_unsigned(c_int, char'length));
						ss <= wait_key;
					else
						lcd_enable <= '0';
					end if;
				when full =>
			end case;
		end if;
	end process;

end architecture;