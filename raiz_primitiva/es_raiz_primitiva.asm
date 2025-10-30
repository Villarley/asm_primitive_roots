
es_raiz_primitiva PROC uses ebx ecx edx esi edi, n:DWORD, p:DWORD
	arrglo[32749]: DWORD ;arreglo para ver si se llegan a repetir / enciclar
	
	lea EDI, arreglo
	mov ECX, p ;ecx es el contador para los p elementos
	xor EAX, EAX
	rep stosd ; pone en 0 cada posicion a ocupar del arreglo
	
	mov ECX, 1 ; el exponente a empezar

probar_exponentes:
	cmp ECX, p ; para parar al llegar a p-1
	jge es_raiz ;si el exponente llega a ser >= p, termina de comparar. (llega a p-1)
	
	INVOKE modular_pow, n, ecx, p ; EAX tiene el resultado de n^a mod p

	lea EDI, arreglo
	mov EBX, EAX ; EBX tiene resultado
	shl EBX, 2 ; multiplicar por 4 para direccionar a sigt
	add EDI, EBX ; EDI apunta a la posicion del resultado

	cmp DWORD PTR [EDI], 1 ; 1 = ya aparecio antes. 0 = no ha salido
	je ciclo_detectado ; si se encicla no es raiz primitiva

    mov DWORD PTR [edi], 1 ;para marcar que ese numero ya salio en el arreglo 

	inc ECX ; siguiente exponente
	jmp probar_exponentes

;resultados
es_raiz:
    mov eax, 1 ;es raíz primitiva
    ret
    
ciclo_detectado:
    xor eax, eax ;no es raíz primitiva
    ret
    
es_raiz_primitiva ENDP