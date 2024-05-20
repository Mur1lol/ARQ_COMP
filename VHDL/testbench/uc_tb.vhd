library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end;

architecture a_uc_tb of uc_tb is
    component uc
        port( 
            clk, rst      : in  std_logic;
        
            -- Contrrole Instrução
            instrucao     : in  unsigned(15 downto 0);
            instr_wr_en   : out std_logic;

            -- Controle PC
            pc_wr_en      : out std_logic;
            pc_sel        : out std_logic := '0';
            pc_data_in    : out unsigned(6 downto 0) := "0000000";

            -- Controle ULA
            ula_sel       : out unsigned (1 downto 0);
            imm           : out unsigned (15 downto 0);
            reg_or_imm    : out std_logic;

            -- Controle Banco
            banco_rst     : out std_logic;
            banco_wr_en   : out std_logic;
            rs1, rs2, rd  : out unsigned(2 downto 0);

            -- Controle Maquina Estados
            estado        : out unsigned(1 downto 0)
        );
    end component;

    constant period_time 	: time		:= 100 ns;
    signal finished			: std_logic := '0';
    signal clk, wr_en, rst, sel	: std_logic;
    
    signal instr_signal : unsigned(15 downto 0);
    

    begin
    -- uut significa Unit Under Test
    uut : uc port map(	
        clk       => clk,
        rst       => rst,
        instrucao => instr_signal
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
        
        
        wait for 300 ns;
        instr_signal <= "0010011000000101"; -- mov R3, 5
        

        wait for 300 ns;
        instr_signal <= "0010100000001000"; -- mov R4, 8

        wait for 300 ns;
        instr_signal <= "0001101011100000"; -- add R5, R3, R4

        wait for 300 ns;
        instr_signal <= "0110101101000001"; -- subi R5, R5, 1

        wait for 300 ns;
        instr_signal <= "1111000000000100"; -- jmp 20

        wait for 300 ns;
        instr_signal <= "0101101101101000"; -- sub R5, R5, R5
        
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