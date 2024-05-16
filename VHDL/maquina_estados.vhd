library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados is
    port( 
        clk, rst   : in  std_logic;
        saida      : out unsigned (1 downto 0)
    );
end entity;

architecture a_maquina_estados of maquina_estados is
    signal estado : unsigned (1 downto 0) := "00";
    begin
    process(clk, rst)  -- acionado se houver mudança em clk ou rst
        begin                
        if rst='1' then
            estado <= "00";
        elsif rising_edge(clk) then
            if estado="10" then
                estado <= "00";
            else
                estado <= estado+1;
            end if;
        end if;
    end process;

    saida <= estado;  -- conexao direta, fora do processo

end architecture;

