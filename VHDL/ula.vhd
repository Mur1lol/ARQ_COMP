library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (
        sel                   : in  unsigned(1 downto 0); -- Seletor de operações (soma, subtração, load e mov)
        entr0, entr1          : in  unsigned(15 downto 0); -- Entrada de 16 bits
        saida                 : out unsigned(15 downto 0); -- Saida 16 bits
        carry, overflow       : out std_logic; -- Flag para Carry e Overflow 
        zero, negative        : out std_logic; -- Flag para Zero e negativo
        menor, maior, igual   : out std_logic  -- Flag para Menor e Maior
    );
end entity;

architecture a_ula of ula is
    signal saida_17, entr0_17, entr1_17 : unsigned(16 downto 0);
    begin
        -- entr0 <= acc
        -- entr1 <= reg OR imm
        entr0_17 <= '0' & entr0;
        entr1_17 <= '0' & entr1;

        saida_17 <=
            (entr0_17 + entr1_17)   when sel="00" else -- SOMA
            (entr0_17 - entr1_17)   when sel="01" else -- SUBTRACAO
            (entr1_17)              when sel="10" else -- LOAD, MOV imm reg
            (entr0_17)              when sel="11" else -- MOV reg imm
            "00000000000000000";

        saida <= saida_17(15 downto 0);

        -- Carry é o MSB da soma 17 bits
        carry <= saida_17(16);

        -- Sinal (ou Negativo), que indica o sinal do resultado da operação mais recente da ULA (ou o sinal do acumulador, depende!), sendo apenas uma cópia do MSB.
        negative <= saida_17(15); 

        menor <= '1' when entr0<entr1 else '0';
        maior <= '1' when entr0>entr1 else '0';
        igual <= '1' when entr0=entr1 else '0';

        -- Zero, que indica que o resultado da operação mais recente da ULA foi zero;
        zero <= 
            '1' when saida_17 = "00000000000000000" else 
            '0';

        -- Overflow, que indica se houve estouro em uma operação sinalizada na ULA (ou seja, que inclui número negativos);
        -- Regras para Detectar Overflow:
        -- soma de dois números positivos é negativo,
        -- soma de dois números negativos é positiva,
        -- subtração de um número negativo e um número positivo é positivo, 
        -- subtração de um número positivo e um número negativo é negativa.
        overflow <=
            '1' when (entr0(15) = entr1(15) AND saida_17(15) /= entr0(15) AND sel="00") OR 
                     (entr0(15) /= entr1(15) AND saida_17(15) = entr1(15) AND sel="01") else
            '0';
            
        

end architecture;