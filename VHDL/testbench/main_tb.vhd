library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is
end;

architecture a_main_tb of main_tb is
    component main
        port(    
            clk, rst, wr_en   : in std_logic;
            mux_sel           : in std_logic; -- SELECIONA SE VAI USAR UM REGISTRADOR OU UM IMEDIATO
            ula_sel           : in unsigned(1 downto 0); -- SELECIONA A OPERAÇÃO NA ULA
            imm               : in unsigned(15 downto 0); -- IMEDIATO
            rs1, rs2, rd      : in unsigned(2 downto 0) -- REGISTRADORES
        );
    end component;

    constant period_time     : time := 100 ns;
    signal finished			 : std_logic := '0';
    signal clk, wr_en, rst	 : std_logic;

    signal mux_sel           : std_logic; 
    signal ula_sel           : unsigned(1 downto 0); 
    signal imm               : unsigned(15 downto 0); 
    signal rs1, rs2, rd      : unsigned(2 downto 0);

    begin 
    uut: main port map ( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en,
        mux_sel   => mux_sel,
        ula_sel   => ula_sel,
        rs1       => rs1,
        rs2       => rs2,   
        rd        => rd,
        imm       => imm
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 1000 ns;
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

    process
    begin 
        rst <= '1';
        wr_en <= '1';
        wait for 200 ns;
        rst <= '0';
        rs2 <= "000"; -- x0

        -- ###########################################################################

        -- addi x1,zero,1; -> x1 = 0+1 = 1
        rd <= "001"; -- x1
        rs1 <= "000"; -- x0
        imm <= "0000000000000001"; -- 1
        mux_sel <= '1'; -- SELECIONA O DADO DO IMEDIATO
        ula_sel <= "00"; -- SELECIONA A OPERAÇÃO DE SOMA
        wait for 100 ns;

        -- addi x2,zero,18; -> x2 = 0+18 = 18
        rd <= "010"; -- x2
        rs1 <= "000"; -- x0
        imm <= "0000000000010010"; -- 18
        mux_sel <= '1'; -- SELECIONA O DADO DO IMEDIATO
        ula_sel <= "00"; -- SELECIONA A OPERAÇÃO DE SOMA
        wait for 100 ns;

        -- add x3,x1,x2; -> x3 = 1+18 = 19
        rd <= "011"; -- x3
        rs1 <= "001"; -- x1
        rs2 <= "010"; -- x2
        mux_sel <= '0'; -- SELECIONA O DADO DO REGISTRADOR
        ula_sel <= "00"; -- SELECIONA A OPERAÇÃO DE SOMA
        wait for 100 ns;

        -- ###########################################################################

        -- sub x4, x3, x1 -> x4 = 19 - 1 = 18
        rd <= "100"; -- x4
        rs1 <= "011"; -- x3
        rs2 <= "001"; -- x1
        mux_sel <= '0'; -- SELECIONA O DADO DO REGISTRADOR
        ula_sel <= "01"; -- SELECIONA A OPERAÇÃO DE SUBTRAÇÃO
        wait for 100 ns;

        -- ###########################################################################

        -- ANDI x5, x4, 2 -> x5 = 18 AND 2 = 2
        rd <= "101"; -- x5
        rs1 <= "100"; -- x4
        imm <= "0000000000000010"; -- 2
        mux_sel <= '1'; -- SELECIONA O DADO DO IMEDIATO
        ula_sel <= "10"; -- SELECIONA A OPERAÇÃO DE AND bit a bit
        wait for 100 ns;

        -- AND x6, x5, x1 -> x6 = 2 AND 1 = 0
        rd <= "110"; -- x6
        rs1 <= "101"; -- x5
        rs2 <= "001"; -- x1
        mux_sel <= '0'; -- SELECIONA O DADO DO REGISTRADOR
        ula_sel <= "10"; -- SELECIONA A OPERAÇÃO DE AND bit a bit
        wait for 100 ns;

        -- ###########################################################################

        -- ORI rd, rs1, imm -> x7 = x6 OR 29 = 29 
        rd <= "111"; -- x7
        rs1 <= "110"; -- x6
        imm <= "0000000000011101"; -- 29
        mux_sel <= '1'; -- SELECIONA O DADO DO IMEDIATO
        ula_sel <= "11"; -- SELECIONA A OPERAÇÃO DE OR bit a bit
        wait for 100 ns;
        
        -- OR rd, rs1, rs2 -> x1 = x7 OR x5 = 31
        rd <= "001"; -- x4
        rs1 <= "111"; -- x7
        rs2 <= "101"; -- x5
        mux_sel <= '0'; -- SELECIONA O DADO DO REGISTRADOR
        ula_sel <= "11"; -- SELECIONA A OPERAÇÃO DE OR bit a bit
        wait;
    end process;
end architecture a_main_tb;

-- ghdl  -a  ula.vhd
-- ghdl  -e  ula

-- ghdl  -a  reg16bits.vhd
-- ghdl  -e  reg16bits

-- ghdl  -a  banco.vhd
-- ghdl  -e  banco

-- ghdl  -a  main.vhd
-- ghdl  -e  main

-- ghdl  -a  main_tb.vhd
-- ghdl  -e  main_tb
-- ghdl  -r  main_tb  --wave=main_tb.ghw

-- gtkwave main_tb.ghw

			