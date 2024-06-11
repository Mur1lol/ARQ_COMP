LD    A, 32
MOV   R7, A   -- R7: Maximo

LD    A, 0
MOV   R6, A   -- R6: Finalizado

ADDI  A, 1
MOV  R1, A    -- R1: i
SW   R1, 0(A) 
CMP  A, R7
BLT  -4

LD A, 1
MOV R1, A     -- R1: 1

-- Inicio loop externo

MOV A, R1
ADDI A, 1
MOV R1, A     -- R1: 2
MOV R2, A     -- R2: 2

LW R4, 0(A)
CMP A, R4
BNE -6        -- Se for diferente, então pula

LD  A, 1
MOV  R3, A    -- R3: Contador

-- Inicio loop interno

MOV A, R3
ADDI A, 1
MOV R3, A

MOV A, R1
ADD R2, A       -- R2 <= R2 + R1

MOV A, R2
SW  R0, 0(A)    -- mem[R2] = R0

CMP A, R7 -- R2-R7       
-- BLT (6) -- JLT (34)  -- Se menor, então pula

MOV A, R1
CMP A, R3 -- R1-R3 
-- BLT (3) -- JLT (34)  -- Se menor, então pula

LD A, 1
MOV R6, A  -- Finalizado = 1

MOV A, R2
CMP A, R7 -- R2-R7 
JNE (20) -- BNE (-16)

-- Fim loop interno

MOV A, R6
CMP A, R0 -- Verifica se Finalizado é maior que 0
JEQ (11) -- BEQ (-25) 

-- Fim loop externo