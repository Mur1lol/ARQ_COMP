library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port (  
        clk, rst   : in  std_logic;
        estado     : out unsigned (1 downto 0);
        PC_out     : out unsigned (6 downto 0);
        reg_instr  : out unsigned (15 downto 0);
        rs1_out    : out unsigned (15 downto 0);
        rs2_out    : out unsigned (15 downto 0);
        acc        : out unsigned (15 downto 0);
        ula_out    : out unsigned (15 downto 0)
    );
end entity;

architecture a_processador of processador is

    component pc is
        port (  
            clk      : in  std_logic;
            wr_en    : in  std_logic;
            data_in  : in  unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    component add1 is
        port(   
            entrada  : in  unsigned(6 downto 0);
            saida    : out unsigned(6 downto 0)
        );
    end component;

    component rom is
        port( 
            clk      : in  std_logic;
            endereco : in  unsigned(6 downto 0);
            dado     : out unsigned(15 downto 0) 
        );
    end component;

    component reg16bits is
        port( 
            clk, rst, wr_en   : in  std_logic;
            data_in           : in  unsigned(15 downto 0);
            data_out          : out unsigned(15 downto 0)
        );
    end component;

    component banco is
        port (  
            clk, rst, wr_en      : in  std_logic;
            rs1, rs2, rd         : in  unsigned(2 downto 0);
            entr                 : in  unsigned(15 downto 0); -- dado de entrada a ser escrito 
            rs1_data, rs2_data   : out unsigned(15 downto 0)
        );
    end component;

    component uc is
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
    
    component ula is
        port(   
            sel                        : in  unsigned(1 downto 0); -- Seletor de operações (soma, subtração, AND bit a bit e OR bit a bit)
            entr0, entr1               : in  unsigned(15 downto 0); -- Entrada de 16 bits
            saida                      : out unsigned(15 downto 0); -- Saida 16 bits
            overflow, zero, negative   : out std_logic -- Flag para Overflow, Zero e negativo
        );
    end component;

    signal ula_result, rs1_data, rs2_data, mux_output  : unsigned(15 downto 0);         
    signal saida_pc, entrada_pc, saida_add1  : unsigned(6 downto 0);  
    signal saida_rom : unsigned(15 downto 0);

    signal instrucao_out : unsigned (15 downto 0);

    signal instr_wr_en   : std_logic;

    -- Controle PC
    signal pc_wr_en      : std_logic := '1';
    signal pc_sel_out        : std_logic := '0';
    signal pc_data_in    : unsigned(6 downto 0) := "0000000";

    -- Controle ULA
    signal ula_sel       : unsigned (1 downto 0);
    signal imm           : unsigned (15 downto 0);
    signal reg_or_imm    : std_logic;

    -- Controle Banco
    signal banco_rst     : std_logic;
    signal banco_wr_en   : std_logic;
    signal rs1_saida, rs2_saida, rd_saida  : unsigned(2 downto 0);

    -- Controle Maquina Estados
   signal estado_out     : unsigned(1 downto 0);

    begin
    pc_instance: pc
    port map(  
        wr_en      =>  pc_wr_en,
        clk        =>  clk,
        data_in    =>  entrada_pc,
        data_out   =>  saida_pc
    );

    add1_instance: add1
    port map(  
        entrada   =>  saida_pc,
        saida     =>  saida_add1
    );

    rom_instance: rom
    port map( 
        clk      => clk,
        endereco => saida_pc,
        dado     => saida_rom 
    );

    instr_instance: reg16bits
    port map( 
        clk      => clk,
        rst      => rst,
        wr_en    => instr_wr_en,
        data_in  => saida_rom,        
        data_out => instrucao_out
    );

    uc_instance: uc
    port map(
        clk => clk, 
        rst => rst,
            
        -- Controle Instrução
        instrucao     => instrucao_out,
        instr_wr_en   => instr_wr_en,

        -- Controle PC
        pc_wr_en      => pc_wr_en,
        pc_sel        => pc_sel_out,
        pc_data_in    => pc_data_in,

        -- Controle ULA
        ula_sel       => ula_sel,
        imm           => imm,
        reg_or_imm    => reg_or_imm,

        -- Controle Banco
        banco_rst     => banco_rst,
        banco_wr_en   => banco_wr_en,
        rs1           => rs1_saida, 
        rs2           => rs2_saida, 
        rd            => rd_saida,

        -- Controle Maquina Estados
        estado        => estado_out
    );

    banco_instance: banco
    port map(  
        wr_en      =>  banco_wr_en,
        clk        =>  clk,
        rst        =>  banco_rst, 
        rs1        =>  rs1_saida,
        rs2        =>  rs2_saida,
        rd         =>  rd_saida,
        entr       =>  ula_result,
        rs1_data   =>  rs1_data,
        rs2_data   =>  rs2_data
    );

    ula_instance: ula 
    port map(   
        sel     =>  ula_sel,
        entr0   =>  rs1_data,
        entr1   =>  mux_output,
        saida   =>  ula_result
    );

    entrada_pc <= 
        pc_data_in when pc_sel_out='0' else
        saida_add1;

    mux_output <= 
        rs2_data   when reg_or_imm = '0' else
        imm        when reg_or_imm = '1' else
        "0000000000000000"; 

    estado     <= estado_out;
    PC_out     <= saida_pc;
    reg_instr  <= instrucao_out;
    rs1_out    <= rs1_data;
    rs2_out    <= rs2_data;
    acc        <= "0000000000000000";
    ula_out    <= ula_result;

end architecture;