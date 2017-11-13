library IEEE;	
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.STD_LOGIC_ARITH.ALL;	 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ranking_ram is	
port ( clk : in std_logic; -- processing clock	
	we : in std_logic; -- write enable signal	 
	wadd : in std_logic_vector(1 downto 0); -- write address to store the data into ram
	radd : in std_logic_vector(1 downto 0); -- read address to read the data from the ram 
	data_in : in std_logic_vector(31 downto 0); -- input data to store into ram	
	data_out : out std_logic_vector(31 downto 0)); -- output data from memory	
end ranking_ram;

architecture Behavioral of ranking_ram is	
-------------------------------------- RAM declaration 
type ram is array(2 downto 0) of std_logic_vector(31 downto 0);	
signal ram1_1 : ram;	
-------------------------------------- Signal declaration 
signal r_add : std_logic_vector(31 downto 0);	
begin	

process(clk, we)	 
begin	
if clk'event and clk = '1' then	
	if we = '1' then -- In this process writing the input data into ram 
	ram1_1(conv_integer(wadd)) <= data_in;	
	end if;	
	r_add <= radd; 
	end if;	
end process;	

data_out <= ram1_1(conv_integer(r_add)); -- Reading the data from RAM 

end Behavioral;	