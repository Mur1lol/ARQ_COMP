library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity puc_tb is
end;

architecture a_puc_tb of puc_tb is
    component puc
        port( 
            clk, sel, wr_en    : in  std_logic;
            data_in  : in  unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    constant period_time 	: time		:= 100 ns;
    signal finished			: std_logic := '0';
    signal clk, wr_en, rst, sel	: std_logic;
    
    signal data_in, data_out : unsigned(15 downto 0);

    begin
    -- uut significa Unit Under Test
    uut : puc port map(	
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
        wait for 200 ns;
        sel <= '0';
        data_in <= "0000000000000000";
        wait for 100 ns;

        sel <= '1';
        
        wait;
    end process;
end architecture;

-- ghdl  -a  puc.vhd
-- ghdl  -e  puc
-- ghdl  -a  puc_tb.vhd
-- ghdl  -e  puc_tb
-- ghdl  -r  puc_tb  --wave=puc_tb.ghw
-- gtkwave puc_tb.ghw