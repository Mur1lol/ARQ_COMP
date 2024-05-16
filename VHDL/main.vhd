library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    port (  
        clk, rst, wr_en   : in  std_logic;
        mux_sel           : in  std_logic; -- SELECIONA SE VAI USAR UM REGISTRADOR OU UM IMEDIATO
        ula_sel           : in  unsigned(1 downto 0); -- SELECIONA A OPERAÇÃO NA ULA
        imm               : in  unsigned(15 downto 0); -- IMEDIATO
        rs1, rs2, rd      : in  unsigned(2 downto 0); -- REGISTRADORES
        saida             : out unsigned(15 downto 0)
    );
end entity;

architecture a_main of main is

    component banco is
        port (  
            clk, rst, wr_en      : in  std_logic;
            rs1, rs2, rd         : in  unsigned(2 downto 0);
            entr                 : in  unsigned(15 downto 0); -- dado de entrada a ser escrito 
            rs1_data, rs2_data   : out unsigned(15 downto 0)
        );
    end component;
    
    component ula is
        port(   
            sel                        : in  unsigned(1 downto 0); -- Seletor de operações (soma, subtração, AND bit a bit e OR bit a bit)
            entr0, entr1               : in  unsigned(15 downto 0); -- Entrada de 16 bits
            saida                      : out unsigned(15 downto 0); -- Saida 16 bits
            overflow, zero, negative   : out std_logic -- Flag para Overflow, Zero e negativo
        );
    end component;

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

    component uc is
        port (

        );
    end component;

    signal ula_result, rs1_data, rs2_data, mux_output  : unsigned(15 downto 0);         
    signal saida_pc, entrada_pc, saida_add1  : unsigned(6 downto 0);  
    signal saida_rom : unsigned(11 downto 0);

    begin
    banco_instance: banco
    port map(  
        wr_en      =>  wr_en,
        clk        =>  clk,
        rst        =>  rst, 
        rs1        =>  rs1,
        rs2        =>  rs2,
        rd         =>  rd,
        entr       =>  ula_result,
        rs1_data   =>  rs1_data,
        rs2_data   =>  rs2_data
    );

    ula_instance: ula 
    port map(   
        sel     =>  ula_sel,
        entr0   =>  rs1_data,
        entr1   =>  mux_output,
        saida   =>  ula_result
    );

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

    uc_instance: uc
    port map(

    );

    entrada_pc <= 
        data_in when sel='0' else
        saida_add1;

    mux_output <= 
        rs2_data   when mux_sel = '0' else
        imm        when mux_sel = '1' else
        "0000000000000000"; 

    saida <= ula_result;

end architecture;
    



