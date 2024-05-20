library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end;

architecture a_pc_tb of pc_tb is
    component pc
        port( 
            clk      : in  std_logic;
            wr_en    : in  std_logic;
            data_in  : in  unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    constant period_time 	: time		:= 100 ns;
    signal finished			: std_logic := '0';
    signal clk, wr_en, rst	: std_logic;
    
    signal data_in, data_out : unsigned(6 downto 0);

    begin
    -- uut significa Unit Under Test
    uut : pc port map(	
        clk      => clk,
        wr_en    => '1',
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

        data_in <= "0000000";
        wait for 100 ns;

        data_in <= "0000001";
        wait for 100 ns;

        data_in <= "0000010";
        wait for 100 ns;

        data_in <= "0000011";
        wait for 100 ns;

        data_in <= "0000100";
        wait for 100 ns;

        data_in <= "0000101";
        wait for 100 ns;

        data_in <= "0000110";
        wait for 100 ns;

        data_in <= "0000111";
        wait for 100 ns;

        data_in <= "0001000";
        wait for 100 ns;

        data_in <= "0001001";
        wait for 100 ns;

        data_in <= "0001010";
        
        wait;
    end process;
end architecture;

-- ghdl  -a  pc.vhd
-- ghdl  -e  pc
-- ghdl  -a  pc_tb.vhd
-- ghdl  -e  pc_tb
-- ghdl  -r  pc_tb  --wave=pc_tb.ghw
-- gtkwave pc_tb.ghw