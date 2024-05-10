library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end;

architecture a_uc_tb of uc_tb is
    component uc
        port( 
            clk, sel, wr_en    : in  std_logic;
            data_in  : in  unsigned(6 downto 0);
            data_out : out unsigned(11 downto 0)
        );
    end component;

    constant period_time 	: time		:= 100 ns;
    signal finished			: std_logic := '0';
    signal clk, wr_en, rst, sel	: std_logic;
    
    signal data_in : unsigned(6 downto 0);
    signal data_out : unsigned(11 downto 0);
    

    begin
    -- uut significa Unit Under Test
    uut : uc port map(	
        clk      => clk,
        wr_en    => '1',
        sel      => sel,
        data_in  => data_in,
        data_out => data_out
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
        sel <= '0';
        data_in <= "0000000";
        wait for 200 ns;
        sel <= '1';

        wait for 100 ns;
        
        
        wait;
    end process;
end architecture;

-- ghdl  -a  pc.vhd
-- ghdl  -e  pc

-- ghdl  -a  add1.vhd
-- ghdl  -e  add1

-- ghdl  -a  maquina_estados.vhd
-- ghdl  -e  maquina_estados

-- ghdl  -a  uc.vhd
-- ghdl  -e  uc
-- ghdl  -a  uc_tb.vhd
-- ghdl  -e  uc_tb
-- ghdl  -r  uc_tb  --wave=uc_tb.ghw
-- gtkwave uc_tb.ghw