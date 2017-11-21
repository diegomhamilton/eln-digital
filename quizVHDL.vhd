library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity quizVHDL is
	port (
		clk		: in std_logic;
		radd		: in std_logic_vector(1 downto 0);
		set	: in std_logic;
		name	: in std_logic_vector(29 downto 0);
		tempo : in std_logic_vector(7 downto 0);
		data_out	: out std_logic_vector(59 downto 0)
		);
end entity;

architecture rtl of quizVHDL is
	signal we			: std_logic;
	signal wadd			: std_logic_vector(1 downto 0);
	signal data_in		: std_logic_vector(59 downto 0);
	
begin
	ram: entity work.ramking port map (clk => clk, we => we, wadd => wadd, radd => radd, data_in => data_in,
													data_out => data_out);
	ranks: entity work.ranking port map (clk => clk, set => set, name => name,
														tempo => tempo, clear => '0',
														data_ram => data_in, addr_ram => wadd, we_ram => we);
end architecture;