library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ranking is
	port (
		clk : in std_logic;
		set : in	std_logic;
		name : in std_logic_vector(29 downto 0);
		tempo : in std_logic_vector(7 downto 0);
		data_ram : out std_logic_vector(59 downto 0);
		addr_ram	: out std_logic_vector(1 downto 0);
		we_ram	: out std_logic;
		clear	: in std_logic
	);
end entity;

architecture rts of ranking is
	type state_type is (s1, s2, s3);
	signal ss : state_type;
	
	signal count : std_logic_vector(1 downto 0);
begin
	process(clk, clear)
		variable t1 : integer range 0 to 151 := 151;
		variable t2 : integer range 0 to 151 := 151;
		variable t3 : integer range 0 to 151 := 151;
		variable time1 : std_logic_vector(29 downto 0);
		variable time2 : std_logic_vector(29 downto 0);
		variable time3 : std_logic_vector(29 downto 0);
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
					end if;
				time1 := std_logic_vector(to_unsigned(t1, 30));
				time2 := std_logic_vector(to_unsigned(t2, 30));
				time3 := std_logic_vector(to_unsigned(t3, 30));
			case ss is
				when s1 =>
				-- salva primeiro colocado na ram
					addr_ram <= "00";
					data_ram <= n1 & time1;
					we_ram <= '1';
					ss <= s2;
				when s2 =>
				-- salva segundo colocado na ram
					addr_ram <= "01";
					data_ram <= n2 & time2;
					we_ram <= '1';
					ss <= s3;
				when s3 =>
				-- salva terceiro colocado na ram
					addr_ram <= "10";
					data_ram <= n3 & time3;
					we_ram <= '1';
					ss <= s1;
			end case;
		end if;
----	DEBUG SESSION
--	no1 <= n1;
--	no2 <= n2;
--	no3 <= n3;
--	to1 <= time1;
--	to2 <= time2;
--	to3 <= time3;
	end process;
end architecture;