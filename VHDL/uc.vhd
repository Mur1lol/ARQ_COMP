library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port( 
        clk, sel, wr_en : in  std_logic;
        data_in         : in  unsigned(6 downto 0);
        data_out        : out unsigned(11 downto 0)
    );
end entity;

architecture a_uc of uc is
    component pc is
        port (  
            clk      : in  std_logic;
            wr_en    : in  std_logic;
            data_in  : in  unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;
    
    component add1 is
        port(   
            entrada  : in  unsigned(6 downto 0);
            saida    : out unsigned(6 downto 0)
        );
    end component;

    component rom is
        port( 
            clk      : in  std_logic;
            endereco : in  unsigned(6 downto 0);
            dado     : out unsigned(11 downto 0) 
        );
    end component;

    component maquina_estados is
        port( 
            clk   : in  std_logic;
            saida : out std_logic
        );
    end component;

    signal saida_pc, entrada_pc, saida_add1, saida_add1_extra  : unsigned(6 downto 0);  
    signal saida_rom : unsigned(11 downto 0);
    signal saida_maquina : std_logic;       
    
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

    rom_instance: rom
    port map( 
        clk      => clk,
        endereco => saida_pc,
        dado     => saida_rom 
    );

    maquina_estados_instance: maquina_estados
    port map( 
        clk   => clk,
        saida => saida_maquina
    );

    saida_add1_extra <= 
        saida_pc when saida_maquina='0' else
        saida_add1;

    entrada_pc <= 
        data_in when sel='0' else
        saida_add1_extra;

    data_out <= saida_rom;

end architecture;