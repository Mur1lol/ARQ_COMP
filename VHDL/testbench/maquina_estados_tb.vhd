library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados_tb is
end;

architecture a_maquina_estados_tb of maquina_estados_tb is
    component maquina_estados
        port( 
            clk, rst, wr_en   : in  std_logic;
            saida             : out std_logic
        );
    end component;

    constant period_time 	: time		:= 100 ns;
    signal finished			: std_logic := '0';
    signal clk, wr_en, rst	: std_logic;
    
    signal saida : std_logic;

    begin
    -- uut significa Unit Under Test
    uut : maquina_estados port map(	
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        saida => saida
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;	-- esperando 2 clocks 
        rst <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';	-- Tempo total da simulação
        wait;
    end process sim_time_proc;
    
    clk_proc: process		-- Aqui geramos os clocks até o tempo de simulação finalizar
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin
        rst <= '1';
        wait for 200 ns;
        wr_en <= '1';
        rst <= '0';
        wait;
    end process;
end architecture;

-- ghdl  -a  maquina_estados.vhd
-- ghdl  -e  maquina_estados
-- ghdl  -a  maquina_estados_tb.vhd
-- ghdl  -e  maquina_estados_tb
-- ghdl  -r  maquina_estados_tb  --wave=maquina_estados_tb.ghw
-- gtkwave maquina_estados_tb.ghw