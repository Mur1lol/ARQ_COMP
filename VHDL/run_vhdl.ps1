# Script PowerShell para rodar comandos GHDL e GTKWave

# Compilar os arquivos VHDL
ghdl -a pc.vhd
ghdl -a maquina_estados.vhd
ghdl -a somador.vhd
ghdl -a rom.vhd
ghdl -a reg16bits.vhd
ghdl -a uc.vhd
ghdl -a banco.vhd
ghdl -a ula.vhd
ghdl -a flags.vhd
ghdl -a ram.vhd
ghdl -a processador.vhd
ghdl -a processador_tb.vhd

# Elaborar as entidades
ghdl -e pc
ghdl -e maquina_estados
ghdl -e somador
ghdl -e rom
ghdl -e reg16bits
ghdl -e uc
ghdl -e banco
ghdl -e ula
ghdl -e flags
ghdl -e ram
ghdl -e processador
ghdl -e processador_tb

# Executar a testbench e gerar o arquivo de ondas
ghdl -r processador_tb --wave=processador_tb.ghw

# Abrir o GTKWave com o arquivo de ondas
Start-Process gtkwave processador_tb.ghw

# Limpar arquivos gerados (opcional, descomente se necessário)
# Remove-Item *.o, *.cf, processador_tb.ghw