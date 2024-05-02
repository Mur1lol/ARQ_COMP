library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    port (  
        clk                        : in std_logic;
        rst                        : in std_logic;
        main_write_enable          : in std_logic;
        mux_entr_sel               : in std_logic; 
        ula_sel                    : in unsigned(1 downto 0);
        main_entr                  : in unsigned(15 downto 0) := "0000000000000001";
        reg_A, reg_B, reg_Write    : in unsigned(2 downto 0)
    );
end entity;

architecture a_main of main is

    component banco is
        port (  
            reg_selec_A      : in unsigned(2 downto 0);
            reg_selec_B      : in unsigned(2 downto 0);    
            regWrite         : in unsigned(2 downto 0);
            entr             : in unsigned(15 downto 0);  
            wr_enable        : in std_logic; 
            clk              : in std_logic; 
            rst              : in std_logic;  
            reg_dataA        : out unsigned(15 downto 0); 
            reg_dataB        : out unsigned(15 downto 0)  
        );
    end component;
    
    component ula is
        port(   
            sel                        : in unsigned(1 downto 0); -- Seletor de operações (soma, subtração, AND bit a bit e OR bit a bit)
            entr0, entr1               : in  unsigned(15 downto 0); -- Entrada de 16 bits
            saida                      : out unsigned(15 downto 0); -- Saida 16 bits
            overflow, zero, negative   : out std_logic -- Flag para Overflow, Zero e negativo
        );
    end component;

    signal ula_result, reg_file_outputA, reg_file_outputB, mux_output  : unsigned(15 downto 0);  
    signal saida_extra : unsigned(15 downto 0);           
    
    begin
    banco_instance: banco
    port map(   
        reg_selec_A     =>  reg_A,
        reg_selec_B     =>  reg_B,
        regWrite        =>  reg_Write,
        entr            =>  ula_result,
        wr_enable       =>  main_write_enable,
        clk             =>  clk,
        rst             =>  rst,
        reg_dataA       =>  reg_file_outputA,
        reg_dataB       =>  reg_file_outputB
    );

    ula_instance: ula 
    port map(   
        sel     =>  ula_sel,
        entr0   =>  reg_file_outputA,
        entr1   =>  mux_output,
        saida   =>  ula_result
    );

    mux_output <= 
        reg_file_outputB when mux_entr_sel = '0' else
        main_entr        when mux_entr_sel = '1' else
        "0000000000000000"; 

    saida_extra <= ula_result;

end architecture;
    



