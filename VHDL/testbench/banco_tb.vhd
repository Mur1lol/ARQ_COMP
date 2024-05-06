library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_tb is
end;

architecture a_banco_tb of banco_tb is
    component banco is
        port (  
            clk, rst, wr_en      : in  std_logic;    
            rs1, rs2, rd         : in  unsigned(2 downto 0); -- registrador 1, registrador 2, registrador Destino
            entr                 : in  unsigned(15 downto 0); -- entrada 
            rs1_data, rs2_data   : out unsigned(15 downto 0) := "0000000000000000"
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk, rst, wr_en : std_logic;
    signal   entr, rs1_data, rs2_data : unsigned(15 downto 0);
    signal   rs1, rs2, rd : unsigned(2 downto 0);

    begin
    uut: banco port map(
        rs1 => rs1,
        rs2 => rs2,
        rd => rd,
        entr => entr,
        wr_en => wr_en,
        clk => clk,
        rst => rst,
        rs1_data => rs1_data,
        rs2_data => rs2_data
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

        rd <= "001";
        rs1 <= "010";
        rs2 <= "000";
        entr <= "0000000000000010";

        wait for 100 ns;

        wr_en <= '0';
        rs1 <= "001"; 
        rs2 <= "010";

        wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
    end process;
end architecture a_banco_tb;