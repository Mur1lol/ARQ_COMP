library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port (
            sel                        : in unsigned(1 downto 0); -- Seletor de operações (soma, subtração, incremento e decremento)
            entr0, entr1               : in  unsigned(15 downto 0); -- Entrada de 16 bits
            saida                      : out unsigned(15 downto 0); -- Saida 16 bits
            maior                      : out std_logic -- Flag para maior
        );
    end component;
    signal entr0, entr1, saida: unsigned(15 downto 0);
    signal sel                : unsigned(1 downto 0);
    signal maior              : std_logic;
begin
    -- uut significa Unit Under Test
    uut : ula port map(
        entr0 => entr0,
        entr1 => entr1,
        maior => maior,
        saida => saida,
        sel => sel
    );

    process
    begin
        entr0 <= "0000000000000001";
        entr1 <= "0000000000000100";

        sel <= "00"; -- SOMA
        wait for 50 ns;

        sel <= "01"; -- SUBTRACAO
        wait for 50 ns;

        sel <= "10"; -- NADA AINDA
        wait for 50 ns;

        sel <= "11"; -- NADA AINDA
        wait for 50 ns;
        wait;
    end process;
end architecture;

-- ghdl  -a  ula.vhd
-- ghdl  -e  ula
-- ghdl  -a  ula_tb.vhd
-- ghdl  -e  ula_tb
-- ghdl  -r  ula_tb  --wave=ula_tb.ghw
-- gtkwave ula_tb.ghw