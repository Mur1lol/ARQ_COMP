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
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo

        -- A. Carrega o valor 1 no endereço 1 da RAM, 2 em 2, 3 em 3
        -- B. Carrega o valor que está no endereço 1 no registrador R1
        -- C. Carrega o valor que está no endereço 2 no registrador R2
        -- D. Carrega o valor que está no endereço 3 no registrador R3
        -- E. Subtrai R3 - R1 e salva em R3


        0  => B"00001_1111_0000000" , --    LD    A, 0
        1  => B"00101_1111_0000001" , -- A: ADDI  A, 1
        2  => B"00010_0001_1111_000", --    MOV  R1, A
        3  => B"11110_0001_1111000" , --    SW   R1, 0(A) 
        4  => B"00111_1111_0000011" , --    CMPI  A, 3
        5  => B"11001_0000_1111100" , --    BLT  -4
        6  => B"00010_1111_0000_000", --    MOV   A, R0
        7  => B"11101_0001_0000001" , -- B: LW   R1, 1(A)
        8  => B"11101_0010_0000010" , -- C: LW   R2, 2(A)
        9  => B"11101_0011_0000011" , -- D: LW   R3, 3(A)
        10 => B"00010_1111_0011_000", --    MOV   A, R3
        11 => B"00011_1111_0001_000", --    SUB   A, R1
        12 => B"00010_0011_1111_000", -- E: MOV  R3, A
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