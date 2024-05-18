library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port( 
        clk, rst        : in  std_logic;
        instruction     : in  unsigned(15 downto 0);

        -- Controle PC
        pc_wr_en : out std_logic;
        pc_sel : out std_logic := '0';
        pc_data_in : unsigned(15 downto 0) := "0000000000000000";

        -- Controle ULA
        ula_sel : out unsigned (1 downto 0);

        -- Controle Banco
        banco_rst : out std_logic;
        banco_wr_en: out std_logic;
        rs1, rs2, rd: out unsigned(2 downto 0);
        imm: out unsigned (5 downto 0);
        reg_or_imm: std_logic;
    );
end entity;

architecture a_uc of uc is
    component maquina_estados is
        port( 
            clk, rst   : in  std_logic;
            saida      : out unsigned (1 downto 0)
        );
    end component;

    
    signal saida_maquina: unsigned(1 downto 0);
    signal opcode       : unsigned(4 downto 0);

    begin
    maquina_estados_instance: maquina_estados
    port map( 
        clk   => clk,
        rst   => rst,
        saida => saida_maquina
    );

    

    -- Fetch
    when saida_maquina="00"
    pc_wr_en    <= '0';
    pc_sel      <= '0';
    banco_wr_en <= '0';

    -- Decode
    when saida_maquina="01"
    opcode <= instruction(15 downto 12);
    rd     <= instruction(11 downto 9);
    rs1    <= instruction(8 downto 6);
    rs2    <= instruction(5 downto 3);
    imm    <= instruction(5 downto 0);

    -- Execute
    when saida_maquina="10"

    -- NOP
    when opcode="0000"
    pc_wr_en='1';

    -- ADD
    when opcode="0001"
    pc_wr_en='1';
    banco_wr_en <= '1';
    reg_or_imm <= '0'; -- REG
    ula_sel <= "00"; -- SOMA

    -- ADDI
    when opcode="0010"
    pc_wr_en='1';
    banco_wr_en <= '1';
    reg_or_imm <= '1'; -- IMM
    ula_sel <= "00"; -- SOMA

    -- SUB
    when opcode="0101"

    -- SUBI
    when opcode="0110"

    -- MOV
    when opcode="1001"

    -- MOVI
    when opcode="1010"
    
    -- JUMP
    when opcode="1111"
    jump_en <=  '1';

    

    process(saida_maquina, opcode)
    begin
    case opcode is
        when "0000" => -- nop
        case saida_maquina is
            when "00" => -- Fetch
                -- Registrador da instrucao
                reg_instruction_wr_en <= '1';

                --PC
                pc_wr_en <= '1';
                jump_en <= '0';
                imm_address <= "0000000";

                -- Banco de Registrador
                register_file_wr_en <= '0';
                reg_selec_A_uc <= "000";
                reg_selec_B_uc <= "000";
                reg_selec_write <= "000";
        
                -- Constante
                immediate_in <= "000000";
                reg_or_imm <= '0';

                --ULA
                sel_op_uc <= "00";

            when "01" => -- Decode
                -- Registrador da instrucao
                reg_instruction_wr_en <= '0';

                --PC
                pc_wr_en <= '0';
                jump_en <= '0';
                imm_address <= "0000000";

                -- Banco de Registrador
                register_file_wr_en <= '0';
                reg_selec_A_uc <= instruction_in(7 downto 5);
                reg_selec_B_uc <= instruction_in(4 downto 2);
                reg_selec_write <= "000";
            
                -- Constante
                immediate_in <= "000000";
                reg_or_imm <= '0';

                --ULA
                sel_op_uc <= "00"; 
                
            when "10" => -- Execute
                -- Registrador da instrucao
                reg_instruction_wr_en <= '0';

                --PC
                pc_wr_en <= '0';
                jump_en <= '0';
                imm_address <= "0000000";

                -- Banco de Registrador
                register_file_wr_en <= '1';
                reg_selec_A_uc <= instruction_in(7 downto 5);
                reg_selec_B_uc <= instruction_in(4 downto 2);
                reg_selec_write <= instruction_in(10 downto 8);
            
                -- Constante
                immediate_in <= "000000";
                reg_or_imm <= '0';

                --ULA
                sel_op_uc <= "00"; -- soma 
            when others =>
        end case;

        when "1111" => -- jump
        case saida_maquina is
            when "00" => -- Fetch
            when "01" => -- Decode
            when "10" => -- Execute
            when others =>
        end case;

        when others =>
        case saida_maquina is
            when "00" => --Fetch
            when "01" => --Fetch
            when "10" => --Fetch
            when others =>
        end case;
    end case;    
end architecture;