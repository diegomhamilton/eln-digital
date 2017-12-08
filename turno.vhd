library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity turno is
	port ( clk		 : in std_logic;
		button_edge	 :	in std_logic_vector(3 downto 0);
		gabarito		 :	in std_logic_vector(3 downto 0);
		fim_turno	 : out std_logic;
		acerto		 : out std_logic;
		start			 : in std_logic;
		tempo			 : out integer range 0 to 30
	);
end entity;

architecture comparation of turno is
	type state is (init, wait_res, comp, result);
	signal ss : state;
	signal acerto_aux	: std_logic;
	signal start_edge : std_logic;
	signal turno	: std_logic;
	component edge_detector is
      port ( clk               : in  STD_LOGIC;
                 signal_in   : in  STD_LOGIC;
                 output         : out  STD_LOGIC);
	end component;
begin
	beginning: edge_detector
			port map (clk => clk, signal_in => start, output => start_edge);
	edge:	edge_detector PORT MAP (
          clk => clk, signal_in => turno, output => fim_turno
        );
	
	process (clk)
	variable resposta: std_logic_vector(3 downto 0);
	variable c	: integer range 0 to 50000000;
	variable k	: integer range 0 to 30;
	begin
		tempo <= k;
		
		if (clk'event and clk='1') then
			c  := c + 1;
			
			case ss is
				when init=>
					turno <= '0';
					acerto_aux <= '0';
					if (start_edge = '1') then 
						ss<= wait_res;
					end if;
				when wait_res => -- etapa de espera da resposta do jogador
					turno <= '0';
					if (k = 30) then
						resposta := "0000";
						ss <= result;
					elsif (button_edge /= "0000") then-- botão pressionado
						resposta := button_edge; -- para comparação posterior
						ss <= comp;
					else									
						if (c = 1) then -- c=50000000
							k := k + 1;
						end if;
						
						ss<= wait_res; -- continua neste estado
					end if;
				when comp => --etapa de verificação da resposta do jogador
					turno <= '0';
					
					if (gabarito = resposta) then
						acerto_aux <= '1';
					else
						acerto_aux <= '0';
					end if;
					
					ss <= result;
				when result=>
					turno <= '1';
					
					if (start_edge = '1') then 
						ss<= wait_res;
					end if;
			end case;
		end if;
	end process;

	acerto <= acerto_aux;
	end architecture;