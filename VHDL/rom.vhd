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

        0  => B"00001_1111_0100000" , -- LD     A, 32
        1  => B"00010_0111_1111_000", -- MOV    R7, A   -- R7: Maximo

        2  => B"00001_1111_0000000" , -- LD     A, 0
        3  => B"00010_0110_1111_000", -- MOV    R6, A   -- R6: Finalizado

        4  => B"00101_1111_0000001" , -- ADDI   A, 1
        5  => B"00010_0001_1111_000", -- MOV    R1, A    -- R1: i
        6  => B"11110_0001_0000000" , -- SW     R1, 0(A) 
        7  => B"00110_1111_0111_000", -- CMP    A, R7
        8  => B"11001_0000_1111100" , -- BLT    (-4)

        9  => B"00001_1111_0000001" , -- LD     A, 1
        10 => B"00010_0001_1111_000", -- MOV    R1, A     -- R1: 1

        -- Inicio loop externo

        11 => B"00010_1111_0001_000", -- MOV    A, R1
        12 => B"00101_1111_0000001" , -- ADDI   A, 1
        13 => B"00010_0001_1111_000", -- MOV    R1, A     -- R1: 2
        14 => B"00010_0010_1111_000", -- MOV    R2, A     -- R2: 2

        15 => B"11101_0100_0000000" , -- LW     R4, 0(A)
        16 => B"00110_1111_0100_000", -- CMP    A, R4
        17 => B"11011_0000_1111010" , -- BNE    (-6)        -- Se for diferente, então pula

        18 => B"00001_1111_0000001" , -- LD     A, 1
        19 => B"00010_0011_1111_000", -- MOV    R3, A    -- R3: Contador

        -- Inicio loop interno

        20 => B"00010_1111_0011_000", -- MOV    A, R3
        21 => B"00101_1111_0000001" , -- ADDI   A, 1
        22 => B"00010_0011_1111_000", -- MOV    R3, A

        23 => B"00010_1111_0001_000", -- MOV    A, R1
        24 => B"00100_0010_1111_000", -- ADD    R2, A       -- R2 <= R2 + R1

        25 => B"00010_1111_0010_000", -- MOV    A, R2
        26 => B"11110_0000_0000000" , -- SW     R0, 0(A)    -- mem[R2] = R0

        27 => B"00110_1111_0111_000", -- CMP    A, R7 -- R2-R7       
        28 => B"11001_0000_0000110" , -- BLT    (6) -- JLT (34)  -- Se menor, então pula

        29 => B"00010_1111_0001_000", -- MOV    A, R1
        30 => B"00110_1111_0011_000", -- CMP    A, R3 -- R1-R3 
        31 => B"11001_0000_0000011" , -- BLT    (3) -- JLT (34)  -- Se menor, então pula

        32 => B"00001_1111_0000001" , -- LD     A, 1
        33 => B"00010_0110_1111_000", -- MOV    R6, A  -- Finalizado = 1

        34 => B"00010_1111_0010_000", -- MOV    A, R2
        35 => B"00110_1111_0111_000", -- CMP    A, R7 -- R2-R7 
        36 => B"01001_0000_0010100" , -- JLT    (20) -- BLT (-16)

        -- Fim loop interno

        37 => B"00010_1111_0110_000", -- MOV    A, R6
        38 => B"00110_1111_0000_000", -- CMP    A, R0 -- Verifica se Finalizado é maior que 0
        39 => B"01100_0000_0001011" , -- JEQ    (11) -- BEQ (-25) 

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