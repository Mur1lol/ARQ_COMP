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
        0   => B"0010_011_000_000101", -- mov R3, 5
        1   => B"0010_100_000_001000", -- mov R4, 8
        2   => B"0001_101_011_100_000", -- add R5, R3, R4
        3   => B"0110_101_101_000001", -- sub R5, R5, 1
        4   => B"1111_000_000_010100", -- jmp 20
        5   => B"0101_101_101_101_000", -- sub R5, R5, R5
        6   => B"0000_000_000_000000", -- nop
        7   => B"0000_000_000_000000", -- nop
        8   => B"0000_000_000_000000", -- nop
        9   => B"0000_000_000_000000", -- nop
        10  => B"0000_000_000_000000", -- nop
        11  => B"0000_000_000_000000", -- nop
        12  => B"0000_000_000_000000", -- nop
        13  => B"0000_000_000_000000", -- nop
        14  => B"0000_000_000_000000", -- nop
        15  => B"0000_000_000_000000", -- nop
        16  => B"0000_000_000_000000", -- nop
        17  => B"0000_000_000_000000", -- nop
        18  => B"0000_000_000_000000", -- nop
        19  => B"0000_000_000_000000", -- nop
        20  => B"1001_011_101_000000", -- mov R3, R5
        21  => B"1111_000_000_000010", -- jmp 2
        22  => B"0101_011_011_011_000", -- sub R3, R3, R3
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