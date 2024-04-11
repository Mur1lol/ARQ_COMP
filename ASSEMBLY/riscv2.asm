		addi s0,zero,0 # Somatorio
		addi s3,zero,5 # N
	externo:	add s4,zero,s3 # Valor = N		
		add s2,zero,s3	# Loop interno = N
	interno: addi s2,s2,-1
		add s0,s0,s4 # Somatorio += Valor
		bne s2,zero,interno
		addi s3,s3,-1 # N += -1
		bne s3,zero, externo