		# Não funciona com 0
		addi s0,zero,3 # Fatorial
		addi a1,zero,1
		addi a2,zero,2
		beq s0,a1,finaln
		beq s0,a2,finaln 
		addi s3,s0,-1 # Iteracoes
		addi s5,zero,1
	externo: addi s3,s3,-1
		add s4,zero,s0
		add s2,zero,s3	
	interno: addi s2,s2,-1
		add s0,s0,s4 # Fatorial = Fatorial + Valor
		bne s2,zero,interno
		bne s3,s5, externo
	finaln:	add s0,zero,s0