
# Arquitetura e Organização de Computadores - UTFPR

## ⚙ Como configurar

### GHDL
Baixar   o  ghdl-MINGW32.zip  da   versão   3.0   em: https://github.com/ghdl/ghdl/releases/tag/v3.0.0

### GTKWAVE
Baixar o `gtkwave-3.3.100-bin-win32` ou então o `gtkwave-3.3.100-bin-win64` que estão em: https://sourceforge.net/projects/gtkwave/files/.

### PATH do Windows para GHDL e GTKWave
Siga os passos ou procure instruções na internet:

1. Vá no Painel de Controle e na barra de busca, digite variáveis.
2. Clique em Editar as variáveis de ambiente; se escolher para o sistema ele abre outra janela e será para todos os usuários do PC, senão é só pra você.
3. Encontre a variável Path (o painel superior é do usuário, o inferior é do sistema):
  - Se   a   variável  Path  não   estiver   listada,   clique   em  Novo...;  coloque  Path  como   nome   e coloque as pastas do ghdl.exe e gtkwave.exe, separadas por ;  
    **(por exemplo, C:\ARQ_COMP\GHDL\bin; C:\ARQ_COMP\GTKWAVE\bin)**.
  - Se a variável Path estiver listada, clique nela e em Editar. Inclua então duas novas linhas, uma para cada aplicativo  
    **(por exemplo, C:\ARQ_COMP\GHDL\bin; C:\ARQ_COMP\GTKWAVE\bin)**.
4. Para testar, abra um terminal (cmd, por ex.) e digite ghdl -v (que deve mostrar a versão do GHDL) e depois gtkwave (que deve abrir o aplicativo).

## 📎 Como executar

Primeiro entre na pasta em que seus arquivos `.vhd ` estão, e em seguida execute os seguintes comandos: 

```
ghdl  -a  nomeArquivo.vhd
ghdl  -e  nomeArquivo

ghdl  -a  nomeArquivo_tb.vhd
ghdl  -e  nomeArquivo_tb
ghdl  -r  nomeArquivo_tb  --wave=nomeArquivo_tb.ghw

gtkwave nomeArquivo_tb.ghw
```