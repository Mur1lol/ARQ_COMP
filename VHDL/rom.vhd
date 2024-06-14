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

        0  => B"11111_1111_0011110" , -- LUI    A, 15360
        1  => B"00101_1111_1000100" , -- ADDI   A, -60
        2  => B"00101_1111_1000011" , -- ADDI   A, -61
        3  => B"00010_0111_1111_000", -- MOV    R7, A   -- R7: Maximo

        4  => B"00001_1111_0000000" , -- LI     A, 0
        5  => B"00010_0110_1111_000", -- MOV    R6, A   -- R6: Finalizado

        6  => B"00101_1111_0000001" , -- ADDI   A, 1
        7  => B"00010_0001_1111_000", -- MOV    R1, A    -- R1: i
        8  => B"11110_0001_0000000" , -- SW     R1, 0(A) 
        9  => B"00110_1111_0111_000", -- CMP    A, R7
        10 => B"11001_0000_1111100" , -- BLT    (-4)

        11 => B"00001_1111_0000001" , -- LI     A, 1
        12 => B"00010_0001_1111_000", -- MOV    R1, A     -- R1: 1

        -- Inicio loop externo

        13 => B"00010_1111_0001_000", -- MOV    A, R1
        14 => B"00101_1111_0000001" , -- ADDI   A, 1
        15 => B"00010_0001_1111_000", -- MOV    R1, A     -- R1: 2
        16 => B"00010_0010_1111_000", -- MOV    R2, A     -- R2: 2

        17 => B"11101_0100_0000000" , -- LW     R4, 0(A)
        18 => B"00110_1111_0100_000", -- CMP    A, R4
        19 => B"11011_0000_1111010" , -- BNE    (-6)        -- Se for diferente, então pula

        20 => B"00001_1111_0000001" , -- LI     A, 1
        21 => B"00010_0011_1111_000", -- MOV    R3, A    -- R3: Contador

        -- Inicio loop interno

        22 => B"00010_1111_0011_000", -- MOV    A, R3
        23 => B"00101_1111_0000001" , -- ADDI   A, 1
        24 => B"00010_0011_1111_000", -- MOV    R3, A

        25 => B"00010_1111_0001_000", -- MOV    A, R1
        26 => B"00100_0010_1111_000", -- ADD    R2, A       -- R2 <= R2 + R1

        27 => B"00010_1111_0010_000", -- MOV    A, R2
        28 => B"11110_0000_0000000" , -- SW     R0, 0(A)    -- mem[R2] = R0

        29 => B"00110_1111_0111_000", -- CMP    A, R7 -- R2-R7       
        30 => B"11001_0000_0000110" , -- BLT    (6) -- JLT (34)  -- Se menor, então pula

        31 => B"00010_1111_0001_000", -- MOV    A, R1
        32 => B"00110_1111_0011_000", -- CMP    A, R3 -- R1-R3 
        33 => B"11001_0000_0000011" , -- BLT    (3) -- JLT (34)  -- Se menor, então pula

        34 => B"00001_1111_0000001" , -- LI     A, 1
        35 => B"00010_0110_1111_000", -- MOV    R6, A  -- Finalizado = 1

        36 => B"00010_1111_0010_000", -- MOV    A, R2
        37 => B"00110_1111_0111_000", -- CMP    A, R7 -- R2-R7 
        38 => B"01001_0000_0010110" , -- JLT    (22) -- BLT (-16)

        -- Fim loop interno

        39 => B"00010_1111_0110_000", -- MOV    A, R6
        40 => B"00110_1111_0000_000", -- CMP    A, R0 -- Verifica se Finalizado é maior que 0
        41 => B"01100_0000_0001101" , -- JEQ    (13) -- BEQ (-25) 

        -- Fim loop externo

        42 => B"00010_1111_0111_000", -- MOV    A, R7
        43 => B"11101_0101_0000000" , -- LW     R5, 0(A)
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