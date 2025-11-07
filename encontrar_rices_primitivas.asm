; --------------------------------------------
; encontrar_raices_primitivas
; --------------------------------------------
encontrar_raices_primitivas PROC
    mov rbx, 2
.loop_encontrar:
    mov rdx, p
    cmp rbx, rdx
    jge .fin_encontrar

    push rbx
    call es_raiz_primitiva_naive
    pop rbx

    cmp rax, 1
    jne .siguiente

    mov rcx, total
    mov raices[rcx*8], rbx
    inc rcx
    mov total, rcx

.siguiente:
    inc rbx
    jmp .loop_encontrar
.fin_encontrar:
    ret
encontrar_raices_primitivas ENDP