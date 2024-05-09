library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port( 
        clk      : in  std_logic;
        wr_en    : in  std_logic := '1';
        data_in  : in  unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_pc of pc is
    signal registro: unsigned(15 downto 0);
    
    begin
    process(clk, wr_en)  -- acionado se houver mudança em clk ou wr_en
        begin                
        if wr_en='1' then
            if rising_edge(clk) then
                registro <= data_in;
            end if;
        end if;
    end process;

    data_out <= registro;  -- conexao direta, fora do processo
end architecture;