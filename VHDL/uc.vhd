library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port( 
        clk, rst       : in  std_logic;
        
        -- Contrrole Instrução
        instrucao      : in  unsigned(15 downto 0);

        -- WRITE ENABLE
        pc_wr_en       : out std_logic;
        banco_wr_en    : out std_logic;
        acc_wr_en      : out std_logic;
        instr_wr_en    : out std_logic;
        ram_wr_en      : out std_logic;
        flags_wr_en    : out std_logic;
        debug_wr_en    : out std_logic;

        -- RESET
        banco_rst      : out std_logic := '0';
        acc_rst        : out std_logic := '0';
        debug_rst      : out std_logic := '0';

        -- Controle PC
        pc_data_in     : out unsigned (6 downto 0);
        jump_or_branch : out unsigned (1 downto 0);

        -- Controle ULA
        ula_sel        : out unsigned (1 downto 0)  := "00";
        imm            : out unsigned (15 downto 0) := "0000000000000000";
        reg_or_imm     : out std_logic              := '0';
        tipo_cmp       : out unsigned (2 downto 0)  := "000";

        -- Controle Banco
        rs2, rd        : out unsigned(3 downto 0) := "0000";
        sel_mux_regs   : out std_logic;

        -- Controle Maquina Estados
        estado         : out unsigned(1 downto 0)
    );
end entity;

architecture a_uc of uc is
    component maquina_estados is
        port( 
            clk, rst   : in  std_logic;
            saida      : out unsigned (1 downto 0)
        );
    end component;

    
    signal saida_maquina : unsigned (1 downto 0) := "00";
    signal opcode        : unsigned (3 downto 0) := "0000";
    signal cmp           : unsigned (3 downto 0) := "0000";
    signal j_or_b_signal : unsigned (1 downto 0) := "00";
    signal rd_signal     : unsigned (3 downto 0) := "0000";
    signal rs2_signal    : unsigned (3 downto 0) := "0000";

    begin
    maquina_estados_instance: maquina_estados
    port map( 
        clk   => clk,
        rst   => rst,
        saida => saida_maquina
    );

    estado <= saida_maquina;

    -- Fetch
    instr_wr_en <= '1' when saida_maquina="00" else '0';
    

    -- Decode
    opcode         <= instrucao(15 downto 12) when saida_maquina="01";
    cmp            <= instrucao(11 downto  8) when saida_maquina="01";

    j_or_b_signal  <=
        -- BRANCH
        "01" when saida_maquina="01" AND (opcode="1010") else
        -- JUMP
        "10" when saida_maquina="01" AND (opcode="1001") else
        -- OTHER
        "00" when saida_maquina="01";
    
    jump_or_branch <= j_or_b_signal;

    pc_wr_en     <= '1' when saida_maquina="01" else '0'; -- Atualiza o PC na execução
    
    pc_data_in   <= instrucao(6 downto 0) when saida_maquina="01"AND (j_or_b_signal="01" OR j_or_b_signal="10") else "0000000";

    tipo_cmp     <= 
        -- MENOR
        "000" when saida_maquina="01" AND (cmp="0001") else
        -- MAIOR
        "001" when saida_maquina="01" AND (cmp="0010") else
        -- DIFERENTE
        "010" when saida_maquina="01" AND (cmp="0011") else
        -- IGUAL
        "011" when saida_maquina="01" AND (cmp="0100") else
        -- SEM CMP
        "100" when saida_maquina="01" AND (cmp="0000");

    reg_or_imm    <=
        -- Imediato
        '1' when saida_maquina="01" AND 
        (
            opcode="0001" OR  -- LI
            opcode="0010" OR  -- LUI
            opcode="0110" OR  -- ADDI
            opcode="1000" OR  -- CMPI
            opcode="1011" OR  -- LW
            opcode="1100"     -- SW
        ) else 
        -- Registrador
        '0' when saida_maquina="01" AND 
        (
            opcode="0011" OR  -- MOV
            opcode="0100" OR  -- SUB
            opcode="0101" OR  -- ADD
            opcode="0111"     -- CMP
        );

    sel_mux_regs <= 
        -- LW
        '0' when (saida_maquina="01" OR saida_maquina="10") AND opcode="1011" else 
        '1';

    -- Execute
    rd_signal  <= 
        instrucao(11 downto  8) when saida_maquina="10" AND 
        (
            opcode="0001" OR  -- LI
            opcode="0010" OR  -- LUI
            opcode="0011" OR  -- MOV
            opcode="0100" OR  -- SUB
            opcode="0101" OR  -- ADD
            opcode="0110" OR  -- ADDI
            opcode="0111" OR  -- CMP
            opcode="1000" OR  -- CMPI
            opcode="1011"     -- LW
        );

    rd <= rd_signal;

    rs2_signal <= instrucao(7  downto  4);
    
    rs2 <= 
        -- RS2 = RD
        instrucao(11 downto  8) when saida_maquina="10" AND
        (
            (opcode="0101" AND rs2_signal="1111") OR -- ADD
            (opcode="1100")                          -- SW
        )
        else
        instrucao(7  downto  4) when saida_maquina="10" AND 
        (
            opcode="0011" OR  -- MOV
            opcode="0100" OR  -- SUB
            opcode="0101" OR  -- ADD
            opcode="0111"     -- CMP
        );

    imm <= 
        (15 downto 8 => instrucao(7)) & instrucao(7  downto  0) when 
        saida_maquina="10" AND
        (
            opcode="0001" OR  -- LI
            opcode="0110" OR  -- ADDI
            opcode="1000" OR  -- CMPI
            opcode="1011" OR  -- LW
            opcode="1100"     -- SW
        ) else
        instrucao(7  downto  0) & (7 downto 0 => '0') when 
        saida_maquina="10" AND
        opcode="0010";  -- LUI

    -- SW
    ram_wr_en    <= '1' when saida_maquina="10" AND opcode="1100" else '0';

    -- LW
    debug_wr_en  <= '1' when saida_maquina="10" AND opcode="1011" else '0';
    
    banco_wr_en  <= 
        '1' when saida_maquina="10" AND rd_signal /= "1111" AND 
        (
            opcode="0011" OR  -- MOV
            opcode="0101" OR  -- ADD
            opcode="1011"     -- LW
        ) else '0';

    acc_wr_en    <= 
        '1' when saida_maquina="10" AND rd_signal = "1111" AND 
        (
            opcode="0001" OR -- LI
            opcode="0010" OR -- LUI
            opcode="0011" OR -- MOV
            opcode="0100" OR -- SUB
            opcode="0101" OR -- ADD
            opcode="0110"    -- ADDI
        ) else '0';

    flags_wr_en  <= 
        '1' when saida_maquina="10" AND 
        (
            opcode="0100" OR -- SUB
            opcode="0101" OR -- ADD
            opcode="0110" OR -- ADDI
            opcode="0111" OR -- CMP
            opcode="1000"    -- CMPI
        ) else '0';   
        
    banco_rst  <= rst;
    acc_rst    <= rst;
    debug_rst  <= rst;

    -- Controle ULA
    ula_sel       <=
        -- ADD, ADDI, LW OR SW
        "00" when saida_maquina="10" AND 
        (opcode="0101" OR opcode="0110" OR opcode="1011" OR opcode="1100") else 
        
        -- SUB, CMP OR CMPI
        "01" when saida_maquina="10" AND 
        (opcode="0100" OR opcode="0111" OR opcode="1000") else 
        
        -- LI, LUI OR MOV (REG)
        "10" when saida_maquina="10" AND 
        (opcode="0001" OR opcode="0010" OR (opcode="0011" AND rd_signal = "1111")) else 
        
        -- MOV (ACC)
        "11" when saida_maquina="10" AND 
        (opcode="0011");

end architecture;