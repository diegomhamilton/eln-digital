library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity turno is
	port ( clk		 : in std_logic;
		button1		 :	in std_logic;
		button2		 :	in std_logic;
		button3		 :	in std_logic;
		button4		 :	in std_logic;
		gabarito		 :	in std_logic_vector(3 downto 0) ;
		fim_turno	 : out std_logic;
		acerto		 : out std_logic;
		tempo			 : out std_logic_vector(4 downto 0) 
	);
end entity;

architecture comparation of turno is
	type state is (init, wait_res, comp, result);
	signal ss : state;
	signal acerto_aux	: std_logic;
	signal pressed : std_logic_vector(3 downto 0);
	component edge_detector is
      port ( clk               : in  STD_LOGIC;
                 signal_in   : in  STD_LOGIC;
                 output         : out  STD_LOGIC);
	end component;
begin
	b1: edge_detector
			port map (clk => clk, signal_in => not(button1), output => pressed(0));
	b2: edge_detector
			port map (clk => clk, signal_in => not(button2), output => pressed(1));
	b3: edge_detector
			port map (clk => clk, signal_in => not(button3), output => pressed(2));
	b4: edge_detector
			port map (clk => clk, signal_in => not(button4), output => pressed(3));
	
	process (clk)
	variable resposta: std_logic_vector(3 downto 0);
	variable c	: integer range 0 to 1; --50000000
	variable k	: integer range 0 to 5; --30
	begin
		if (clk'event and clk='1') then
			c  := c + 1;
			
			case ss is
				when init=>
					fim_turno <= '0';
					ss<= wait_res;
				when wait_res => -- etapa de espera da resposta do jogador
					fim_turno <= '0';
					if (k = 5) then -- tempo esgotado = erro (k = 30)
						resposta := "0000";
						ss <= result;
					elsif (pressed /= "0000") then-- botão pressionado
						resposta := pressed; -- para comparação posterior
						ss <= comp;
						tempo <= std_logic_vector(to_unsigned(k, 5));
					else									
						if (c = 1) then -- c=50000000
							k := k + 1;
						end if;
						
						ss<= wait_res; -- continua neste estado
					end if;
				when comp => --etapa de verificação da resposta do jogador
					fim_turno <= '0';
					
					if (gabarito = resposta) then
						acerto_aux <= '1';
					else
						acerto_aux <= '0';
					end if;
					
					ss <= result;
				when result=>
					if (acerto_aux = '1') then
						-- print acertou
					else
						-- print errou
					end if;
					
					fim_turno <= '1';
			end case;
		end if;
	end process;
		
	acerto <= acerto_aux;
	end architecture;