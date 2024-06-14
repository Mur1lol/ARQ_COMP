library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    component processador
        port(    
            clk, rst     : in  std_logic;
            estado       : out unsigned (1 downto 0);
            saida_PC     : out unsigned (6 downto 0);
            reg_instr    : out unsigned (15 downto 0);
            saida_rs1    : out unsigned (15 downto 0);
            saida_rs2    : out unsigned (15 downto 0);
            saida_acc    : out unsigned (15 downto 0);
            saida_ula    : out unsigned (15 downto 0);
            bit_debug    : out std_logic
        );
    end component;

    constant period_time     : time := 10 ns;
    signal finished			 : std_logic := '0';
    signal clk, wr_en, rst	 : std_logic;

    begin 
    uut: processador port map ( 
        clk       => clk,
        rst       => rst
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time;
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        -- wait for 50000000 ns;
        -- wait for 37522400 ns;
        -- wait for 25014965 ns;
        wait for 12504885 ns;
        finished <= '1';	
        wait;
    end process sim_time_proc;

    clk_proc: process		
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    
end architecture a_processador_tb;

-- ghdl  -a  pc.vhd
-- ghdl  -e  pc

-- ghdl  -a  add1.vhd
-- ghdl  -e  add1

-- ghdl  -a  rom.vhd
-- ghdl  -e  rom

-- ghdl  -a  reg16bits.vhd
-- ghdl  -e  reg16bits

-- ghdl  -a  uc.vhd
-- ghdl  -e  uc

-- ghdl  -a  banco.vhd
-- ghdl  -e  banco

-- ghdl  -a  ula.vhd
-- ghdl  -e  ula

-- ghdl  -a  processador.vhd
-- ghdl  -e  processador

-- ghdl  -a  processador_tb.vhd
-- ghdl  -e  processador_tb
-- ghdl  -r  processador_tb  --wave=processador_tb.ghw

-- gtkwave processador_tb.ghw		