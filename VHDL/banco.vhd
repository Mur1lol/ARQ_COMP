library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco is
    port ( 
        reg_selec_A, reg_selec_B, regWrite : in unsigned(2 downto 0);
        entr                               : in unsigned(15 downto 0); -- dado de entrada a ser escrito 
        clk, rst, wr_enable                : in  std_logic;
        reg_dataA, reg_dataB               : out unsigned(15 downto 0) := "0000000000000000" -- dado do segundo registrador lido 
    );
end entity;

architecture a_banco of banco is
    component reg16bits is
        port( 
            clk, rst, wr_en   : in  std_logic;
            data_in           : in  unsigned(15 downto 0);
            data_out          : out unsigned(15 downto 0)
        );
    end component;

    signal data_in: unsigned(15 downto 0) := "0000000000000000";
    signal wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5, wr_en_6, wr_en_7 : std_logic;    
    signal data_out_0, data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7   :   unsigned(15 downto 0) := "0000000000000000";  
     
    begin
    x0: reg16bits
    port map( 
        clk       => clk,
        rst       => '1',
        wr_en     => '0',
        data_in   => data_in,
        data_out  => data_out_0
    );

    x1: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_1,
        data_in   => data_in,
        data_out  => data_out_1  
    );  

    x2: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_2,
        data_in   => data_in,
        data_out  => data_out_2  
    );  

    x3: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_3,
        data_in   => data_in,
        data_out  => data_out_3  
    );  

    x4: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_4,
        data_in   => data_in,
        data_out  => data_out_4  
    );  

    x5: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_5,
        data_in   => data_in,
        data_out  => data_out_5  
    );  

    x6: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_6,
        data_in   => data_in,
        data_out  => data_out_6  
    );  

    acc: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_7,
        data_in   => data_in,
        data_out  => data_out_7  
    );  

    data_in <= entr;

    -- Vamos ter que usar 3 mux

    -- Preparando registrador para escrita
    wr_en_1 <= '1' when wr_enable='1' and regWrite="001" else '0';
    wr_en_2 <= '1' when wr_enable='1' and regWrite="010" else '0';
    wr_en_3 <= '1' when wr_enable='1' and regWrite="011" else '0';
    wr_en_4 <= '1' when wr_enable='1' and regWrite="100" else '0';
    wr_en_5 <= '1' when wr_enable='1' and regWrite="101" else '0';
    wr_en_6 <= '1' when wr_enable='1' and regWrite="110" else '0';
    wr_en_7 <= '1' when wr_enable='1' and regWrite="111" else '0';

    -- Leitura do primeiro registrador
    reg_dataA <= 
        data_out_0 when reg_selec_A="000" else
        data_out_1 when reg_selec_A="001" else
        data_out_2 when reg_selec_A="010" else
        data_out_3 when reg_selec_A="011" else
        data_out_4 when reg_selec_A="100" else
        data_out_5 when reg_selec_A="101" else
        data_out_6 when reg_selec_A="110" else
        data_out_7 when reg_selec_A="111" else
        "0000000000000000";
    
    -- Leitura do segundo registrador
    reg_dataB <= 
        data_out_0 when reg_selec_B="000" else
        data_out_1 when reg_selec_B="001" else
        data_out_2 when reg_selec_B="010" else
        data_out_3 when reg_selec_B="011" else
        data_out_4 when reg_selec_B="100" else
        data_out_5 when reg_selec_B="101" else
        data_out_6 when reg_selec_B="110" else
        data_out_7 when reg_selec_B="111" else
        "0000000000000000";

end architecture;