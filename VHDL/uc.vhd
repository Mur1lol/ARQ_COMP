library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port( 
        clk, rst        : in  std_logic;
        instruction_in  : in  unsigned(11 downto 0);


        -- PCWriteCond     : out
        -- PCWrite         : out
        -- IorD            : out
        -- MemRead         : out
        -- MemWrite        : out
        -- MemtoReg        : out
        -- IRWrite         : out

        -- PCSource        : out
        -- ALUOp           : out
        -- ALUSrcB         : out
        -- ALUSrcA         : out
        -- RegWrite        : out
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

    opcode <= instruction_in(11 downto 8);

    jump_en <=  '1' when opcode="1111" else
               '0';

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