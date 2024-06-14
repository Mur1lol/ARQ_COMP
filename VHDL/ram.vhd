library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------------------------------------
entity ram is
    port (
        clk      : in std_logic;
        endereco : in unsigned(13 downto 0);
        wr_en    : in std_logic;
        dado_in  : in unsigned(15 downto 0);
        dado_out : out unsigned(15 downto 0)
    );
end entity;
------------------------------------------------------------------------
architecture a_ram of ram is
    type mem is array (0 to 16383) of unsigned(15 downto 0);
    signal conteudo_ram : mem;
begin
    process (clk, wr_en)
    begin
        if wr_en = '1' then
            if rising_edge(clk) then
                conteudo_ram(to_integer(endereco)) <= dado_in;
            end if;
        end if;
    end process;
    dado_out <= conteudo_ram(to_integer(endereco));
end architecture;