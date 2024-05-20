library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add1 is
    port( 
        entrada  : in  unsigned(6 downto 0);
        saida    : out unsigned(6 downto 0)
    );
end entity;

architecture a_add1 of add1 is
    begin 
    saida <= entrada + 1;
    
end architecture;