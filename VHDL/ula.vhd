library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (
        sel                        : in  unsigned(1 downto 0); -- Seletor de operações (soma, subtração, AND bit a bit e OR bit a bit)
        entr0, entr1               : in  unsigned(15 downto 0); -- Entrada de 16 bits
        saida                      : out unsigned(15 downto 0); -- Saida 16 bits
        overflow, zero, negative   : out std_logic -- Flag para Overflow, Zero e negativo
    );
end entity;

architecture a_ula of ula is
    signal sinal_saida : unsigned(15 downto 0);
    signal sinal_overflow, sinal_zero, sinal_negative : std_logic;
    begin
        sinal_saida <=    
            (entr0 + entr1)   when sel="00" else -- SOMA
            (entr0 - entr1)   when sel="01" else -- SUBTRACAO
            (entr0 AND entr1) when sel="10" else -- AND bit a bit
            (entr0 OR entr1)  when sel="11" else -- OR bit a bit
            "0000000000000000";

        -- Zero, que indica que o resultado da operação mais recente da ULA foi zero;
        sinal_zero <= 
            '1' when sinal_saida = "0000000000000000" else 
            '0';

        -- Sinal (ou Negativo), que indica o sinal do resultado da operação mais recente da ULA (ou o sinal do acumulador, depende!), sendo apenas uma cópia do MSB.
        sinal_negative <= sinal_saida(15); 

        -- Overflow, que indica se houve estouro em uma operação sinalizada na ULA (ou seja, que inclui número negativos);
        sinal_overflow <= 
            '1' when ((entr0(15) = '1' AND entr0(15) = entr1(15)) OR (entr0(15) /= entr1(15) AND sinal_saida(15) = '0')) AND (sel = "00" OR sel = "01") else
            '0';

        zero <= sinal_zero;
        negative <= sinal_negative;
        overflow <= sinal_overflow;
        saida <= sinal_saida;

end architecture;