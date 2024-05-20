library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port( 
        clk, rst      : in  std_logic;
        
        -- Contrrole Instrução
        instrucao     : in  unsigned(15 downto 0);
        instr_wr_en   : out std_logic;

        -- Controle PC
        pc_wr_en      : out std_logic := '1';
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
end entity;

architecture a_uc of uc is
    component maquina_estados is
        port( 
            clk, rst   : in  std_logic;
            saida      : out unsigned (1 downto 0)
        );
    end component;

    
    signal saida_maquina : unsigned(1 downto 0);
    signal opcode        : unsigned(3 downto 0);
    signal jump_en       : std_logic;

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
    opcode      <= instrucao(15 downto 12) when saida_maquina="01";
    jump_en       <= '1' when saida_maquina="01" AND opcode="1111" else '0';

    pc_wr_en      <= '1' when saida_maquina="01" else '0'; -- Atualiza o PC na execução
    pc_sel        <= '0' when saida_maquina="01" AND jump_en='1' else '1'; -- Seleciona a entrada de dados com endereço do jump
    pc_data_in    <= "0" & instrucao(5 downto 0) when saida_maquina="01" AND jump_en='1' else "0000000";

    

    -- Execute
    rd          <= instrucao(11 downto  9) when saida_maquina="10" AND opcode/="1111" else "000";
    rs1         <= instrucao(8  downto  6) when saida_maquina="10" AND opcode/="1010" AND opcode/="1111" else "000"; -- rs1 <= "000" when MOVI OR JUMP
    rs2         <= instrucao(5  downto  3) when saida_maquina="10" AND opcode/="1001" AND (opcode="0001" OR opcode="0101") else "000"; -- rs2 <= "000" when MOV
    imm         <= "0000000000" & instrucao(5  downto  0) when saida_maquina="10" else "0000000000000000";
    
    -- Controle ULA
    ula_sel       <=
        "00" when saida_maquina="10" AND (opcode="0001" OR opcode="0010" OR opcode="1001" OR opcode="1010") else
        "01" when saida_maquina="10" AND (opcode="0101" OR opcode="0110") else
        "00";

    reg_or_imm    <=
        '1' when saida_maquina="10" AND (opcode="0010" OR opcode="0110" OR opcode="1010" OR opcode="0010") else -- Imediato
        '0' ;-- Registrador

    -- Controle Banco
    banco_wr_en   <= '1' when saida_maquina="10" AND (opcode/="0000" AND opcode/="1111") else '0';
end architecture;