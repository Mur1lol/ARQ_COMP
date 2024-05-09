library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add1_tb is
end;

architecture a_add1_tb of add1_tb is
    component add1 is
        port( 
            clk      : in  std_logic;
            entrada  : in  unsigned(15 downto 0);
            saida    : out unsigned(15 downto 0)
        );
    end component;
    
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk, rst, wr_en : std_logic;

    signal entrada, saida : unsigned(15 downto 0);

    begin
    uut: add1 port map(
        clk => clk,
        entrada => entrada,
        saida => saida
    );
    
    rst_global: process
    begin
        rst <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        rst <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process                      -- sinais dos casos de teste (p.ex.)
    begin
        wait for 200 ns;
        wr_en <= '1';
        data_in <= "0000000000000001";



        wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
    end process;
end architecture a_add1_tb;

-- ghdl  -a  add1.vhd
-- ghdl  -e  add1
-- ghdl  -a  add1_tb.vhd
-- ghdl  -e  add1_tb
-- ghdl  -r  add1_tb  --wave=add1_tb.ghw
-- gtkwave add1_tb.ghw