library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port (  
        clk, rst   : in  std_logic;
        estado     : out unsigned (1 downto 0);
        saida_PC     : out unsigned (6 downto 0);
        reg_instr  : out unsigned (15 downto 0);
        saida_rs1    : out unsigned (15 downto 0);
        saida_rs2    : out unsigned (15 downto 0);
        saida_acc        : out unsigned (15 downto 0);
        saida_ula    : out unsigned (15 downto 0)
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

    component somador is
        port(   
            entr0   : in  unsigned(6 downto 0);
            entr1   : in  unsigned(6 downto 0);
            saida   : out unsigned(6 downto 0)
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
            rs1, rs2, rd         : in  unsigned(3 downto 0);
            entr                 : in  unsigned(15 downto 0); -- dado de entrada a ser escrito 
            rs1_data, rs2_data   : out unsigned(15 downto 0)
        );
    end component;

    component uc is
        port( 
            clk, rst       : in  std_logic;
            instrucao      : in  unsigned(15 downto 0);

            -- WRITE ENABLE
            pc_wr_en       : out std_logic;
            banco_wr_en    : out std_logic;
            acc_wr_en      : out std_logic;
            instr_wr_en    : out std_logic;
            ram_wr_en      : out std_logic;
            flags_wr_en    : out std_logic;

            -- RESET
            banco_rst      : out std_logic := '0';
            acc_rst        : out std_logic := '0';

            -- Controle PC
            pc_data_in     : out unsigned (6 downto 0);
            jump_or_branch : out unsigned (1 downto 0);

            -- Controle ULA
            ula_sel        : out unsigned (1 downto 0);
            imm            : out unsigned (15 downto 0);
            reg_or_imm     : out std_logic;
            tipo_cmp       : out unsigned (2 downto 0);

            -- Controle Banco
            rs2, rd        : out unsigned (3 downto 0);
            sel_mux_regs   : out std_logic;

            -- Controle Maquina Estados
            estado         : out unsigned (1 downto 0)
        );
    end component;
    
    component ula is
        port(   
            sel                   : in  unsigned(1 downto 0); -- Seletor de operações (soma, subtração, load e OR bit a bit)
            entr0, entr1          : in  unsigned(15 downto 0); -- Entrada de 16 bits
            saida                 : out unsigned(15 downto 0); -- Saida 16 bits
            carry, overflow       : out std_logic; -- Flag para Carry e Overflow 
            zero, negative        : out std_logic  -- Flag para Zero e negativo
        );
    end component;

    component flags is
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
    end component;

    component ram is
        port (
            clk      : in std_logic;
            endereco : in unsigned(13 downto 0);
            wr_en    : in std_logic;
            dado_in  : in unsigned(15 downto 0);
            dado_out : out unsigned(15 downto 0)
        );
    end component;

    ------------------------------------------------------------------------------

    -- WRITE ENABLE
    signal pc_wr_en       : std_logic;
    signal banco_wr_en    : std_logic;
    signal acc_wr_en      : std_logic;
    signal instr_wr_en    : std_logic;
    signal flags_wr_en    : std_logic;

    -- RESET
    signal banco_rst      : std_logic;
    signal acc_rst        : std_logic;

    -- PC
    signal pc_out         : unsigned (6 downto 0);
    signal mux_pc         : unsigned (6 downto 0);
    signal mux_somador    : unsigned (6 downto 0);
    signal pc_sel         : std_logic;
    signal add1_out       : unsigned (6 downto 0); 
    signal somador_out    : unsigned (6 downto 0);

    -- ROM
    signal rom_out        : unsigned (15 downto 0);
    
    -- INSTRUÇÂO
    signal instrucao_out  : unsigned (15 downto 0);

    -- UC
    signal reg_or_imm     : std_logic;
    signal imm            : unsigned (15 downto 0);
    signal rs2_out        : unsigned (3 downto 0);
    signal rd_out         : unsigned (3 downto 0);
    signal pc_data_in     : unsigned (6 downto 0);
    signal ula_sel        : unsigned (1 downto 0);
    signal j_or_b         : unsigned (1 downto 0);
    signal estado_out     : unsigned (1 downto 0);
    signal tipo_cmp       : unsigned (2 downto 0); 
    signal sel_mux_regs   : std_logic;

    -- BANCO
    signal rs1_data       : unsigned (15 downto 0); 
    signal rs2_data       : unsigned (15 downto 0);
    signal mux_banco      : unsigned (15 downto 0); 

    -- ULA
    signal ula_out        : unsigned (15 downto 0);
    signal mux_ula        : unsigned (15 downto 0);
    signal zero_in       : std_logic; 
    signal negative_in   : std_logic; 
    signal carry_in      : std_logic; 
    signal overflow_in   : std_logic; 

    -- FLAGS
    signal zero_out       : std_logic; 
    signal negative_out   : std_logic; 
    signal carry_out      : std_logic; 
    signal overflow_out   : std_logic;

    -- RAM
    signal ram_wr_en      : std_logic;
    signal ram_in         : unsigned (13 downto 0);
    signal ram_out        : unsigned (15 downto 0);

    -- ACC
    signal acc_out        : unsigned (15 downto 0);
    ------------------------------------------------------------------------------

    begin
    pc_instance: pc
    port map(  
        clk        =>  clk,
        wr_en      =>  pc_wr_en,
        data_in    =>  mux_pc,
        data_out   =>  pc_out
    );

    add1_instance: somador
    port map(  
        entr0   =>  pc_out,
        entr1   => "0000001",
        saida   =>  add1_out
    );

    somador_instance: somador
    port map(  
        entr0   =>  pc_data_in,
        entr1   =>  mux_somador,
        saida   =>  somador_out
    );

    rom_instance: rom
    port map( 
        clk      => clk,
        endereco => pc_out,
        dado     => rom_out 
    );

    instr_instance: reg16bits
    port map( 
        clk      => clk,
        rst      => rst,
        wr_en    => instr_wr_en,
        data_in  => rom_out,        
        data_out => instrucao_out
    );

    uc_instance: uc
    port map(
        clk     => clk, 
        rst     => rst,       
        instrucao => instrucao_out,     

        -- WRITE ENABLE
        pc_wr_en     => pc_wr_en,      
        banco_wr_en  => banco_wr_en,
        acc_wr_en    => acc_wr_en,     
        instr_wr_en  => instr_wr_en,  
        ram_wr_en    => ram_wr_en, 
        flags_wr_en  => flags_wr_en,

        -- RESET
        banco_rst  =>  banco_rst,   
        acc_rst => acc_rst,   

        -- Controle PC
        pc_data_in  => pc_data_in,   
        jump_or_branch => j_or_b,

        -- Controle ULA
        ula_sel => ula_sel,        
        imm =>  imm,          
        reg_or_imm => reg_or_imm,
        tipo_cmp => tipo_cmp,     

        -- Controle Banco
        rs2 => rs2_out, 
        rd  => rd_out,    
        sel_mux_regs => sel_mux_regs,

        -- Controle Maquina Estados
        estado  => estado_out       
    );

    acc_instance: reg16bits
    port map( 
        clk      => clk,
        rst      => acc_rst,
        wr_en    => acc_wr_en,
        data_in  => ula_out,        
        data_out => acc_out
    );

    banco_instance: banco
    port map(  
        clk        =>  clk,
        wr_en      =>  banco_wr_en,
        rst        =>  banco_rst, 
        rs1        =>  "0000",
        rs2        =>  rs2_out,
        rd         =>  rd_out,
        entr       =>  mux_banco,
        rs1_data   =>  rs1_data,
        rs2_data   =>  rs2_data
    );

    ula_instance: ula 
    port map(   
        sel      =>  ula_sel,
        entr0    =>  acc_out,
        entr1    =>  mux_ula,
        saida    =>  ula_out,
        carry    => carry_in,
        overflow => overflow_in, 
        zero     => zero_in, 
        negative => negative_in
    );

    flags_instance: flags 
    port map( 
        clk         => clk, 
        wr_en       => flags_wr_en,

        carry_in     => carry_in,
        overflow_in  => overflow_in,
        zero_in      => zero_in,
        negative_in  => negative_in,
        
        carry_out     => carry_out,
        overflow_out  => overflow_out,
        zero_out      => zero_out,
        negative_out  => negative_out    
    );

    ram_instance: ram
    port map (
        clk      => clk,
        endereco => ram_in,
        wr_en    => ram_wr_en,
        dado_in  => rs2_data,
        dado_out => ram_out
    );

    mux_somador <=
        pc_out when j_or_b="01" else
        "0000000";

    pc_sel <= 
        '1' when (j_or_b="01" OR j_or_b="10") AND
                 (
                    (tipo_cmp = "000" AND negative_out='1') OR  -- MENOR
                    (tipo_cmp = "001" AND negative_out='0') OR  -- MAIOR
                    (tipo_cmp = "010" AND zero_out='0') OR   -- DIFF
                    (tipo_cmp = "011" AND zero_out='1') OR  -- IGUAL
                    (tipo_cmp = "100")
                 ) else
        '0';

    mux_pc <= 
        add1_out when pc_sel='0' else
        somador_out;

    ram_in <= ula_out(13 downto 0);

    mux_banco <=
        ram_out when sel_mux_regs = '0' else
        ula_out;

    mux_ula <= 
        rs2_data   when reg_or_imm = '0' else
        imm        when reg_or_imm = '1' else
        "0000000000000000"; 

    estado     <= estado_out;
    saida_pc   <= pc_out;
    reg_instr  <= instrucao_out;
    saida_rs1  <= rs1_data;
    saida_rs2  <= rs2_data;
    saida_acc  <= acc_out;
    saida_ula  <= ula_out;

end architecture;