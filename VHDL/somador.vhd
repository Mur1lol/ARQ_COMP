library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador is
    port( 
        entr0   : in  unsigned(6 downto 0);
        entr1   : in  unsigned(6 downto 0);
        saida   : out unsigned(6 downto 0)
    );
end entity;

architecture a_somador of somador is
    begin 
    saida <= entr0 + entr1;
    
end architecture;