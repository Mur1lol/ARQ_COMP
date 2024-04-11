library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (
        sel                        : in unsigned(1 downto 0); -- Seletor de operações (soma, subtração, incremento e decremento)
        entr0, entr1               : in  unsigned(15 downto 0); -- Entrada de 16 bits
        saida                      : out unsigned(15 downto 0); -- Saida 16 bits
        maior                      : out std_logic -- Flag para maior
    );
end entity;

architecture a_ula of ula is
    signal sinal_maior : std_logic;
    begin
        sinal_maior <= 
            '1' when entr0>entr1 else
            '0' when entr0<=entr1 else
            '0';

        maior <= '0';

        saida <=    
            (entr0 + entr1) when sel="00" else -- SOMA
            (entr0 - entr1) when sel="01" AND sinal_maior='1' else -- SUBTRACAO
            (entr1 - entr0) when sel="01" AND sinal_maior='0' else  -- SUBTRACAO
            entr0 when sel="10" else
            entr1 when sel="11" else
            "0000000000000000";         
end architecture;