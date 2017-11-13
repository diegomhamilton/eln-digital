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
		clear	: in std_logic;
	);
end entity;

architecture rts of ranking is

begin
	process(clk, clear)
		variable t1 : integer range 0 to 151 := 151;
		variable t2 : integer range 0 to 151 := 151;
		variable t3 : integer range 0 to 151 := 151;
		variable n1 : std_logic_vector(23 downto 0);
		variable n2 : std_logic_vector(23 downto 0);
		variable n3 : std_logic_vector(23 downto 0);
	begin
		if (clear = '1') then
			t1 := ;
			t2 := 151;
			t3 := 151;
			n1 := std_logic_vector(to_unsigned(0, n1'length));
			n2 := std_logic_vector(to_unsigned(0, n2'length));
			n3 := std_logic_vector(to_unsigned(0, n3'length));
		elsif (rising_edge(clk)) then
			if (set = '1') then
				if (tempo < t1) then
					t3 := t2;
					n3 := n2;
					t2 := t1;
					n2 := n1;
					t1 := to_integer(unsigned(tempo));
					n1 := name;
				elsif (tempo < t2) then
					t3 := t2;
					n3 := n2;
					t2 := to_integer(unsigned(tempo));
					n2 := name;
				elsif (tempo < t3) then
					t3 := to_integer(unsigned(tempo));
					n3 := name;
				end if;
			end if;
		end if;
		
		time1 <= std_logic_vector(to_unsigned(t1, time1'length));
		time2 <= std_logic_vector(to_unsigned(t2, time2'length));
		time3 <= std_logic_vector(to_unsigned(t3, time3'length));
		name1 <= n1;
		name2 <= n2;
		name3 <= n3;
	end process;
end architecture;