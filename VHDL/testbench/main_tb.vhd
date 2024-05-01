library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is
end;

architecture a_main_tb of main_tb is
    component main
        port(    clk                        : in std_logic;
                 rst                        : in std_logic;
                 main_write_enable          : in std_logic;
                 mux_entr_sel               : in std_logic; 
                 ula_sel                    : in unsigned(1 downto 0);
                 main_entr                  : in unsigned(15 downto 0);
                 reg_A, reg_B, reg_Write    : in unsigned(2 downto 0)
        );
        end component;

        constant period_time 	: time		:= 100 ns;
		signal finished			: std_logic := '0';
		signal clk, rst	        : std_logic;
        signal wr_en            : std_logic := '0';

        begin
            uut: main port map ( clk                => clk,
                                 rst                => rst,
                                 main_write_enable  => wr_en,
                                 mux_entr_sel       => '1',
                                 ula_sel            => "00",
                                 reg_A              => "001",
                                 reg_B              => "110",   
                                 reg_Write          => "011",
                                 main_entr          => "0000000000000100");

            reset_global: process
            begin
                rst <= '1';
                wait for period_time*2;
                rst <= '0';
                wait;
            end process;

            sim_time_proc: process
			begin
				wait for 10 us;
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
                wait for 200 ns;
                wr_en <= '1';
                wait for 100 ns;
                wr_en <= '0';
                wait;
            end process;
end architecture a_main_tb;

			