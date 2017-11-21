library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

ENTITY decoder_3bits IS
  PORT(
    clk        : IN    STD_LOGIC;  
    numb_input  : IN    INTEGER RANGE 0 TO 999;  
    asci_output   : OUT   STD_LOGIC_VECTOR(29 DOWNTO 0));
END decoder_3bits;

ARCHITECTURE behavior OF decoder_3bits IS
  
	BEGIN
  
	PROCESS(clk)
		
  		VARIABLE aux      : INTEGER RANGE 0 TO 999;
		
		VARIABLE counter1 : INTEGER RANGE 0 TO 9;
		VARIABLE counter2 : INTEGER RANGE 0 TO 9;
		VARIABLE counter3 : INTEGER RANGE 0 TO 9;
		
		BEGIN
		
		  IF(rising_edge(clk)) THEN
		  aux := numb_input;
		  counter1 := aux MOD 10;
		  counter2 := ((aux - counter1)/10) MOD 10;
		  counter3 := (aux - counter2*10)/100;
			
		  CASE counter1 IS 
				
				WHEN 0 => asci_output(9 downto 0) <= "1000110000";
				WHEN 1 => asci_output(9 downto 0) <= "1000110001";
				WHEN 2 => asci_output(9 downto 0) <= "1000110010";
				WHEN 3 => asci_output(9 downto 0) <= "1000110011";
				WHEN 4 => asci_output(9 downto 0) <= "1000110100";
				WHEN 5 => asci_output(9 downto 0) <= "1000110101";
				WHEN 6 => asci_output(9 downto 0) <= "1000110110";
				WHEN 7 => asci_output(9 downto 0) <= "1000110111";
				WHEN 8 => asci_output(9 downto 0) <= "1000111000";
				WHEN 9 => asci_output(9 downto 0) <= "1000111001";
				
			END CASE;
			
			CASE counter2 IS 
				
				WHEN 0 => asci_output(19 downto 10) <= "1000110000";
				WHEN 1 => asci_output(19 downto 10) <= "1000110001";
				WHEN 2 => asci_output(19 downto 10) <= "1000110010";
				WHEN 3 => asci_output(19 downto 10) <= "1000110011";
				WHEN 4 => asci_output(19 downto 10) <= "1000110100";
				WHEN 5 => asci_output(19 downto 10) <= "1000110101";
				WHEN 6 => asci_output(19 downto 10) <= "1000110110";
				WHEN 7 => asci_output(19 downto 10) <= "1000110111";
				WHEN 8 => asci_output(19 downto 10) <= "1000111000";
				WHEN 9 => asci_output(19 downto 10) <= "1000111001";
				
			END CASE;
			
			CASE counter3 IS 
				
				WHEN 0 => asci_output(29 downto 20) <= "1000110000";
				WHEN 1 => asci_output(29 downto 20) <= "1000110001";
				WHEN 2 => asci_output(29 downto 20) <= "1000110010";
				WHEN 3 => asci_output(29 downto 20) <= "1000110011";
				WHEN 4 => asci_output(29 downto 20) <= "1000110100";
				WHEN 5 => asci_output(29 downto 20) <= "1000110101";
				WHEN 6 => asci_output(29 downto 20) <= "1000110110";
				WHEN 7 => asci_output(29 downto 20) <= "1000110111";
				WHEN 8 => asci_output(29 downto 20) <= "1000111000";
				WHEN 9 => asci_output(29 downto 20) <= "1000111001";
				
			END CASE;
		  
		  
		  END IF;
		   

				END PROCESS;
		END behavior;
