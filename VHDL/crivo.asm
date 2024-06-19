LUI A, 15360 (0011 110)
ADDI A, -60 (1000100)
ADDI A, -61 (1000011)

-- 15239

MOV R7, A

LI    A, 0
MOV   R6, A   -- R6: Finalizado

ADDI  A, 1
MOV  R1, A    -- R1: i
SW   R1, 0(A) 
CMP  A, R7
BLT  -4

LI A, 1
MOV R1, A     -- R1: 1

-- Inicio loop externo

MOV A, R1
ADDI A, 1
MOV R1, A     -- R1: 2
MOV R2, A     -- R2: 2

LW R4, 0(A)
CMP A, R4
BNE -6        -- Se for diferente, então pula

LI  A, 1
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
BLT (6) -- JLT (34)  -- Se menor, então pula

MOV A, R1
CMP A, R3 -- R1-R3 
BLT (3) -- JLT (34)  -- Se menor, então pula

LI A, 1
MOV R6, A  -- Finalizado = 1

MOV A, R2
CMP A, R7 -- R2-R7 
JLT (22) -- BLT (-16)

-- Fim loop interno

MOV A, R6
CMP A, R0 -- Verifica se Finalizado é maior que 0
JEQ (13) -- BEQ (-25) 

-- Fim loop externo

MOV A, R7
LW  R5, 0(A)

