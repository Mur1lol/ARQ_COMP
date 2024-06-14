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

        -- RESET
        banco_rst      : out std_logic := '0';
        acc_rst        : out std_logic := '0';

        -- Controle PC
        pc_data_in     : out unsigned (6 downto 0);
        jump_or_branch : out unsigned (1 downto 0);

        -- Controle ULA
        ula_sel        : out unsigned (1 downto 0);
        imm            : out unsigned (15 downto 0) := "0000000000000000";
        reg_or_imm     : out std_logic;
        tipo_cmp       : out unsigned (2 downto 0);

        -- Controle Banco
        rs2, rd        : out unsigned(3 downto 0);
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
    signal opcode        : unsigned (4 downto 0) := "00000";
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
    opcode         <= instrucao(15 downto 11) when saida_maquina="01";
    j_or_b_signal  <=
        "01" when (opcode="11000" OR opcode="11001" OR opcode="11010" OR opcode="11011" OR opcode="11100") AND saida_maquina="01" else
        "10" when (opcode="01000" OR opcode="01001" OR opcode="01010" OR opcode="01011" OR opcode="01100") AND saida_maquina="01" else
        "00" when (opcode/="11000" AND opcode/="11001" AND opcode/="11010" AND opcode/="11011" AND opcode/="11100" AND 
                opcode/="01000" AND opcode/="01001" AND opcode/="01010" AND opcode/="01011" AND opcode/="01100") AND 
                saida_maquina="01";
    pc_wr_en       <= '1' when saida_maquina="01" else '0'; -- Atualiza o PC na execução
    pc_data_in     <= instrucao(6 downto 0) when saida_maquina="01"AND (j_or_b_signal="01" OR j_or_b_signal="10") else "0000000";
    
    jump_or_branch <= j_or_b_signal;

    tipo_cmp     <= 
        "000" when saida_maquina="01" AND (opcode="01001" OR opcode="11001") else
        "001" when saida_maquina="01" AND (opcode="01010" OR opcode="11010") else
        "010" when saida_maquina="01" AND (opcode="01011" OR opcode="11011") else
        "011" when saida_maquina="01" AND (opcode="01100" OR opcode="11100") else
        "100" when saida_maquina="01" AND (opcode="01000" OR opcode="11000");

    reg_or_imm    <=
        -- Imediato
        '1' when saida_maquina="01" AND 
        (opcode="00001" OR opcode="00101" OR opcode="00111" OR 
        opcode="11101" OR opcode="11110" OR opcode="11111") else 
        -- Registrador
        '0' when saida_maquina="01" AND 
        (opcode="00010" OR opcode="00011" OR opcode="00100" OR opcode="00110");

    -- entr <= saida_ram when 0    (LW)
    sel_mux_regs <= 
        '0' when (saida_maquina="01" OR saida_maquina="10") AND opcode="11101" else 
        '1';

    -- Execute
    rd_signal  <= 
        instrucao(10 downto  7) when saida_maquina="10" AND 
        (opcode="00001" OR opcode="00010" OR opcode="00011" OR opcode="00100" OR 
        opcode="00101" OR opcode="00110" OR opcode="00111" OR opcode="11101" OR opcode="11111");

    rd <= rd_signal;

    rs2_signal <= instrucao(6  downto  3);
    
    rs2 <= 
        instrucao(10 downto  7) when saida_maquina="10" AND
        (opcode="11110" OR ((opcode="00011" OR opcode="00100") AND rs2_signal="1111"))
    else
        instrucao(6  downto  3) when saida_maquina="10" AND 
        (opcode="00010" OR opcode="00011" OR 
        opcode="00100" OR opcode="00110") 
    ;

    imm <= 
        (15 downto 7 => instrucao(6)) & instrucao(6  downto  0) when saida_maquina="10" AND
        (opcode="00001" OR opcode="00101" OR opcode="00111" OR 
        opcode="11101" OR opcode="11110") else
        instrucao(6  downto  0) & (8 downto 0 => '0') when saida_maquina="10" AND
        (opcode="11111");

    ram_wr_en <= '1' when saida_maquina="10" AND opcode="11110" else '0';
    
    banco_wr_en   <= 
        '1' when saida_maquina="10" AND rd_signal /= "1111" AND 
        (opcode="00010" OR opcode="00011" OR opcode="00100" OR opcode="11101") else 
        '0';

    acc_wr_en     <= 
        '1' when saida_maquina="10" AND rd_signal = "1111" AND 
        (opcode="00001" OR opcode="00010" OR opcode="00011" OR 
        opcode="00100" OR opcode="00101" OR opcode="11111") else 
        '0';

    flags_wr_en    <= 
        '1' when saida_maquina="10" AND 
        (opcode="00110" OR opcode="00111" OR opcode="00100" OR opcode="00101" OR opcode="00011") 
        else
        '0';              

    -- Controle ULA
    ula_sel       <=
        -- ADD OR ADDI
        "00" when saida_maquina="10" AND 
        (opcode="00100" OR opcode="00101" OR opcode="11101" OR opcode="11110") else 
        -- SUB
        "01" when saida_maquina="10" AND 
        (opcode="00011" OR opcode="00110" OR opcode="00111") else 
        -- LI OR LUI
        "10" when saida_maquina="10" AND 
        (opcode="00001" OR opcode="11111" OR (opcode="00010" AND rd_signal = "1111")) else 
        -- MOV
        "11" when saida_maquina="10" AND 
        (opcode="00010");

end architecture;