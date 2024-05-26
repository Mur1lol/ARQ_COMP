library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( 
        clk      : in  std_logic;
        endereco : in  unsigned(6 downto 0);
        dado     : out unsigned(15 downto 0) 
    );
end entity;
architecture a_rom of rom is
    type mem is array (0 to 65535) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo

        -- A. Carrega R3 (o registrador 3) com o valor 0
        -- B. Carrega R4 com 0
        -- C. Soma R3 com R4 e guarda em R4
        -- D. Soma 1 em R3
        -- E. Se R3<30 salta para a instrução do passo C *
        -- F. Copia valor de R4 para R5

        0  => B"00001_1111_0000000" , --    LD    A, 0
        1  => B"00010_0011_1111_000", -- A: MOV  R3, A 
        2  => B"00010_0100_1111_000", -- B: MOV  R4, A
        3  => B"00010_1111_0011_000", -- C: MOV   A, R3
        4  => B"00100_0100_0100_000", --    ADD  R4, A
        5  => B"00101_1111_0000001" , --    ADDI  A, 1
        6  => B"00010_0011_0011_000", -- D: MOV  R3, A
        7  => B"00111_1111_0011110" , --    CMPI   A, 30 
        8  => B"11001_0000_1111011" , -- E: BLT  -5 (C)
        -- 8  => B"01001_0000_0000011" , -- E: JLT  3 (C)
        9  => B"00010_1111_0100_000", --    MOV   A, R4
        10 => B"00010_0101_1111_000", -- F: MOV  R5, A
        -- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
    );

    begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;