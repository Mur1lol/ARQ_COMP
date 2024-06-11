library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flags is
    port( 
        clk, wr_en   : in  std_logic;

        carry_in     : in std_logic;
        overflow_in  : in std_logic;
        zero_in      : in std_logic;
        negative_in  : in std_logic;
        
        carry_out     : out std_logic;
        overflow_out  : out std_logic;
        zero_out      : out std_logic;
        negative_out  : out std_logic
    );
end entity;

architecture a_flags of flags is
    signal carry    : std_logic := '0';
    signal overflow : std_logic := '0';
    signal zero     : std_logic := '0';
    signal negative : std_logic := '0';

    begin
    process(clk, wr_en)  -- acionado se houver mudança em clk ou wr_en
        begin                
        if  wr_en='1' then
            if rising_edge(clk) then
                carry     <= carry_in;
                overflow  <= overflow_in;
                zero      <= zero_in;
                negative  <= negative_in;
            end if;
        end if;
    end process;

    carry_out     <= carry;
    overflow_out  <= overflow;
    zero_out      <= zero;
    negative_out  <= negative;
end architecture;