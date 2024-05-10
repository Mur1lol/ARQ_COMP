library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados is
    port( 
        clk   : in  std_logic;
        saida : out std_logic
    );
end entity;

architecture a_maquina_estados of maquina_estados is
    signal estado : std_logic := '0';
    begin
    process(clk)  -- acionado se houver mudança em clk, rst ou wr_en
        begin                
        if rising_edge(clk) then
            estado <= not estado;
        end if;
    end process;

    saida <= estado;  -- conexao direta, fora do processo
end architecture;