; ------------------------------------------------------------
; Exponenciacion modular (base ^ exponente mod m)
; ------------------------------------------------------------

extrn printf : proc
extrn scanf  : proc
extrn getchar : proc
extrn ExitProcess : proc

includelib msvcrt.lib
includelib legacy_stdio_definitions.lib
includelib kernel32.lib

.DATA
    base       dq 3
    exponente  dq 4
    modulo     dq 5
    resultado  dq ?
    msg        db "Resultado: %I64d", 10, 0

SIZE_ARREGLO EQU 131072
    arreglo    dd SIZE_ARREGLO dup(0)
    p          dq 17
    total      dq 0
    raices     dq 16384 dup(0)  ; preveer para el caso de primos muy grandes

    fmtInP     db "Escriba el numero primo: ",0
    fmtLeer    db "%I64d",0
    fmtRootOut db "%I64d ",0
    fmtNL      db 10,0
    msgPrueba  db "Raices primitivas de p=%I64d: ",0

.CODE
; ------------------------------------------------------------
; Programa principal
; ------------------------------------------------------------
main PROC
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    ; pruebas iniciales
    mov qword ptr [p], 5
    call ejecutar_prueba
    
    mov qword ptr [p], 7
    call ejecutar_prueba
    
    mov qword ptr [p], 11
    call ejecutar_prueba

    ; pedir primo al usuario
    lea rcx, fmtInP
    xor eax, eax
    call printf

    lea rcx, fmtLeer
    lea rdx, p
    xor eax, eax
    call scanf

    ; Limpiar contador
    xor rax, rax
    mov qword ptr [total], rax

    ; Encontrar raices primitivas
    mov rbx, 2
loop_encontrar:
    mov r12, qword ptr [p]
    cmp rbx, r12
    jge imprimir_raices

    mov rcx, rbx
    mov rdx, r12
    call es_raiz_primitiva

    cmp rax, 1
    jne siguiente_n

    ; Guardar raiz
    mov r13, qword ptr [total]
    lea r14, raices
    mov qword ptr [r14 + r13*8], rbx
    inc r13
    mov qword ptr [total], r13

siguiente_n:
    inc rbx
    jmp loop_encontrar

imprimir_raices:
    mov r12, qword ptr [total]
    xor r13, r13
    lea r15, raices

imprimir_loop:
    cmp r13, r12
    jge imprimir_fin

    mov rdx, qword ptr [r15 + r13*8]
    lea rcx, fmtRootOut
    xor eax, eax
    call printf

    inc r13
    jmp imprimir_loop

imprimir_fin:
    lea rcx, fmtNL
    xor eax, eax
    call printf

    ; Salir limpiamente
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    
    xor ecx, ecx
    call ExitProcess
main ENDP

; ------------------------------------------------------------
; Para ejecutar las pruebas iniciales
; ------------------------------------------------------------
ejecutar_prueba PROC
    push rbx
    push r12
    push r13
    sub rsp, 32

    lea rcx, msgPrueba
    mov rdx, qword ptr [p]
    xor eax, eax
    call printf

    mov rbx, 2
prueba_loop:
    mov r12, qword ptr [p]
    cmp rbx, r12
    jge prueba_imprimir

    mov rcx, rbx
    mov rdx, r12
    call es_raiz_primitiva

    cmp rax, 1
    jne prueba_siguiente

    mov rdx, rbx
    lea rcx, fmtRootOut
    xor eax, eax
    call printf

prueba_siguiente:
    inc rbx
    jmp prueba_loop

prueba_imprimir:
    lea rcx, fmtNL
    xor eax, eax
    call printf

    add rsp, 32
    pop r13
    pop r12
    pop rbx
    ret
ejecutar_prueba ENDP

; ------------------------------------------------------------
; Verifica si n es raiz primitiva modulo p
; Entrada: rcx = n, rdx = p
; Salida: rax = 1 si es raiz primitiva, 0 si no
; ------------------------------------------------------------
es_raiz_primitiva PROC
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    sub rsp, 40

    mov r12, rcx
    mov r13, rdx

    ; Limpiar arreglo
    lea rdi, arreglo
    mov ecx, SIZE_ARREGLO
    xor eax, eax
    rep stosd

    mov r14, 1

probar_exponentes:
    cmp r14, r13
    jge es_raiz

    mov rcx, r12
    mov rdx, r14
    mov r8,  r13
    call mod_exp

    cmp rax, SIZE_ARREGLO
    jae ciclo_detectado

    lea rdi, arreglo
    mov rbx, rax
    lea rdi, [rdi + rbx*4]

    cmp dword ptr [rdi], 1
    je ciclo_detectado

    mov dword ptr [rdi], 1

    inc r14
    jmp probar_exponentes

es_raiz:
    mov eax, 1
    jmp fin_raiz

ciclo_detectado:
    xor eax, eax

fin_raiz:
    add rsp, 40
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret
es_raiz_primitiva ENDP

; ------------------------------------------------------------
; Exponenciacion modular: (base ^ exponente) mod modulo
; Entrada: rcx = base, rdx = exponente, r8 = modulo
; Salida: rax = resultado
; ------------------------------------------------------------
mod_exp PROC
    push rbx
    push r12
    push r13
    
    mov r9,  r8
    mov rbx, rcx
    mov r10, rdx
    mov rax, 1

    ; base %= modulo
    mov rax, rbx
    xor rdx, rdx
    div r9
    mov rbx, rdx
    mov rax, 1

ciclo_modexp:
    test r10, r10
    jz fin_modexp

    test r10, 1
    jz base_cuadrado

    mov r12, rax
    mul rbx
    div r9
    mov rax, rdx

base_cuadrado:
    mov r13, rax
    mov rax, rbx
    mul rbx
    div r9
    mov rbx, rdx
    mov rax, r13

    shr r10, 1
    jmp ciclo_modexp

fin_modexp:
    pop r13
    pop r12
    pop rbx
    ret
mod_exp ENDP

END