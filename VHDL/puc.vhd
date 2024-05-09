library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity puc is
    port( 
        clk, sel, wr_en    : in  std_logic;
        data_in  : in  unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_puc of puc is
    component pc is
        port (  
            clk      : in  std_logic;
            wr_en    : in  std_logic := '1';
            data_in  : in  unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    
    component add1 is
        port(   
            entrada  : in  unsigned(15 downto 0);
            saida    : out unsigned(15 downto 0)
        );
    end component;

    signal saida_pc, entrada_pc, saida_add1  : unsigned(15 downto 0);         
    
    begin
    pc_instance: pc
    port map(  
        wr_en      =>  wr_en,
        clk        =>  clk,
        data_in    =>  entrada_pc,
        data_out   =>  saida_pc
    );

    add1_instance: add1
    port map(  
        entrada   =>  saida_pc,
        saida     =>  saida_add1
    );

    entrada_pc <= 
        data_in when sel='0' else
        saida_add1;

    data_out <= entrada_pc;

end architecture;