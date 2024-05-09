library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end;

architecture a_rom_tb of rom_tb is
    component rom
        port( 
            clk      : in  std_logic;
            endereco : in  unsigned(6 downto 0);
            dado     : out unsigned(11 downto 0) 
        );
    end component;

    constant period_time 	: time		:= 100 ns;
    signal finished			: std_logic := '0';
    signal clk, wr_en, rst	: std_logic;
    
    signal endereco     : unsigned(6 downto 0);
    signal dado         : unsigned(11 downto 0);

    begin
    -- uut significa Unit Under Test
    uut : rom port map(	
        clk => clk,
        endereco => endereco,
        dado => dado
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

        endereco <= "0000000";
        wait for 100 ns;

        endereco <= "0000001";
        wait for 100 ns;

        endereco <= "0000010";
        wait for 100 ns;

        endereco <= "0000011";
        wait for 100 ns;

        endereco <= "0000100";
        wait for 100 ns;

        endereco <= "0000101";
        wait for 100 ns;

        endereco <= "0000110";
        wait for 100 ns;

        endereco <= "0000111";
        wait for 100 ns;

        endereco <= "0001000";
        wait for 100 ns;

        endereco <= "0001001";
        wait for 100 ns;

        endereco <= "0001010";
        
        wait;
    end process;
end architecture;

-- ghdl  -a  rom.vhd
-- ghdl  -e  rom
-- ghdl  -a  rom_tb.vhd
-- ghdl  -e  rom_tb
-- ghdl  -r  rom_tb  --wave=rom_tb.ghw
-- gtkwave rom_tb.ghw