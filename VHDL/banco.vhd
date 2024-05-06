library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco is
    port ( 
        clk, rst, wr_en      : in  std_logic;    
        rs1, rs2, rd         : in  unsigned(2 downto 0); -- registrador 1, registrador 2, registrador Destino
        entr                 : in  unsigned(15 downto 0); -- entrada 
        rs1_data, rs2_data   : out unsigned(15 downto 0) := "0000000000000000"
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

    signal wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5, wr_en_6, wr_en_7 : std_logic;    
    signal data_out_0, data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7   :   unsigned(15 downto 0);  
     
    begin
    x0: reg16bits
    port map( 
        clk       => clk,
        rst       => '1',
        wr_en     => '0',
        data_in   => entr,
        data_out  => data_out_0
    );

    x1: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_1,
        data_in   => entr,
        data_out  => data_out_1  
    );  

    x2: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_2,
        data_in   => entr,
        data_out  => data_out_2  
    );  

    x3: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_3,
        data_in   => entr,
        data_out  => data_out_3  
    );  

    x4: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_4,
        data_in   => entr,
        data_out  => data_out_4  
    );  

    x5: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_5,
        data_in   => entr,
        data_out  => data_out_5  
    );  

    x6: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_6,
        data_in   => entr,
        data_out  => data_out_6  
    );  

    x7: reg16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_7,
        data_in   => entr,
        data_out  => data_out_7  
    );  

    -- Vamos ter que usar 3 mux

    -- Preparando registrador para escrita
    wr_en_1 <= '1' when wr_en='1' and rd="001" else '0';
    wr_en_2 <= '1' when wr_en='1' and rd="010" else '0';
    wr_en_3 <= '1' when wr_en='1' and rd="011" else '0';
    wr_en_4 <= '1' when wr_en='1' and rd="100" else '0';
    wr_en_5 <= '1' when wr_en='1' and rd="101" else '0';
    wr_en_6 <= '1' when wr_en='1' and rd="110" else '0';
    wr_en_7 <= '1' when wr_en='1' and rd="111" else '0';

    -- data_out_1 <= "0000000000000000" when wr_en_1='1' else "0000000000000000";

    -- Leitura do primeiro registrador
    rs1_data <= 
        data_out_0 when rs1="000" else
        data_out_1 when rs1="001" else
        data_out_2 when rs1="010" else
        data_out_3 when rs1="011" else
        data_out_4 when rs1="100" else
        data_out_5 when rs1="101" else
        data_out_6 when rs1="110" else
        data_out_7 when rs1="111" else
        "0000000000000000";
    
    -- Leitura do segundo registrador
    rs2_data <= 
        data_out_0 when rs2="000" else
        data_out_1 when rs2="001" else
        data_out_2 when rs2="010" else
        data_out_3 when rs2="011" else
        data_out_4 when rs2="100" else
        data_out_5 when rs2="101" else
        data_out_6 when rs2="110" else
        data_out_7 when rs2="111" else
        "0000000000000000";

end architecture;