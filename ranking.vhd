library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ranking is
	port (
--		no1 : out std_logic_vector(29 downto 0);--////////////////////////////////////////////
--		no2 : out std_logic_vector(29 downto 0);--////////////////////////////////////////////
--		no3 : out std_logic_vector(29 downto 0);--///////////DEBUG////////////////////////////
--		to1 : out std_logic_vector(9 downto 0);	--/////////////////DEBUG//////////////////////
--		to2 : out std_logic_vector(9 downto 0);	--///////////////////////DEBUG////////////////
--		to3 : out std_logic_vector(9 downto 0); --////////////////////////////////////////////
		clk : in std_logic;
		set : in	std_logic;
		name : in std_logic_vector(29 downto 0);
		tempo : in std_logic_vector(7 downto 0); 
		clear	: in std_logic
	);
end entity;

architecture rts of ranking is
	signal we			: std_logic;
	signal wadd			: std_logic_vector(1 downto 0);
	signal radd			: std_logic_vector(1 downto 0);
	signal data_in		: std_logic_vector(39 downto 0);
	signal data_out	: std_logic_vector(39 downto 0);
	
	component ranking_ram is	
	port ( clk : in std_logic; -- processing clock	
		we : in std_logic; -- write enable signal	 
		wadd : in std_logic_vector(1 downto 0); -- write address to store the data into ram
		radd : in std_logic_vector(1 downto 0); -- read address to read the data from the ram 
		data_in : in std_logic_vector(39 downto 0); -- input data to store into ram	
		data_out : out std_logic_vector(39	downto 0) -- output data from memory
		);	
	end component;
	
	type state_type is (s0, s1, s2, s3);
	signal ss : state_type;
	
	signal count : std_logic_vector(1 downto 0);
begin
	ram: ranking_ram
		port map (clk => clk, we => we, wadd => wadd, radd => radd,
					data_in => data_in, data_out => data_out);
	
	process(clk, clear)
		variable t1 : integer range 0 to 151 := 151;
		variable t2 : integer range 0 to 151 := 151;
		variable t3 : integer range 0 to 151 := 151;
		variable time1 : std_logic_vector(9 downto 0);
		variable time2 : std_logic_vector(9 downto 0);
		variable time3 : std_logic_vector(9 downto 0);
		variable n1 : std_logic_vector(29 downto 0);
		variable n2 : std_logic_vector(29 downto 0);
		variable n3 : std_logic_vector(29 downto 0);
	begin
		if (clear = '1') then
			t1 := 151;
			t2 := 151;
			t3 := 151;	
			n1 := std_logic_vector(to_unsigned(0, n1'length));
			n2 := std_logic_vector(to_unsigned(0, n2'length));
			n3 := std_logic_vector(to_unsigned(0, n3'length));
		elsif (rising_edge(clk)) then
			case ss is
				when s0 =>
				-- insere novo jogador no ranking
					if (set = '1') then
						if (tempo < t1) then
						-- se o jogador fez um tempo menor que o primeiro colocado (default 151), ele é colocado como primeiro
							t3 := t2;
							n3 := n2;
							t2 := t1;
							n2 := n1;
							t1 := to_integer(unsigned(tempo));
							n1 := name;
						elsif (tempo < t2 and n1 /= name) then
						-- se o jogador fez um tempo menor que o segundo colocado (default 151) e ainda não está no ranking
						-- ele é colocado como segundo
							t3 := t2;
							n3 := n2;
							t2 := to_integer(unsigned(tempo));
							n2 := name;
						elsif (tempo < t3 and (n1 /= name and n2 /= name)) then
						-- se o jogador fez um tempo menor que o terceiro colocado (default 151) e ainda não está no ranking
						-- ele é colocado como terceiro
							t3 := to_integer(unsigned(tempo));
							n3 := name;
						end if;
						
						ss <= s0;
					else
						ss <= s1;
					end if;
				time1 := "10" & std_logic_vector(to_unsigned(t1, 8));
				time2 := "10" & std_logic_vector(to_unsigned(t2, 8));
				time3 := "10" & std_logic_vector(to_unsigned(t3, 8));
				
				when s1 =>
				-- salva primeiro colocado na ram
					wadd <= "00";
					data_in <= n1 & time1;
					we <= '1';
					ss <= s2;
				when s2 =>
				-- salva segundo colocado na ram
					wadd <= "01";
					data_in <= n2 & time2;
					we <= '1';
					ss <= s3;
				when s3 =>
				-- salva terceiro colocado na ram
					wadd <= "10";
					data_in <= n3 & time3;
					we <= '1';
					ss <= s0;
			end case;
		end if;
--	DEBUG SESSION
--	no1 <= n1;
--	no2 <= n2;
--	no3 <= n3;
--	to1 <= time1;
--	to2 <= time2;
--	to3 <= time3;
	end process;
end architecture;