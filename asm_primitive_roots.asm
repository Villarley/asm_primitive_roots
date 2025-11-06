; ------------------------------------------------------------
; Exponenciación modular (base ^ exponente mod m)
; Ejemplo: base=3, exponente=4, m=5 → resultado=1
; ------------------------------------------------------------

extrn printf : proc
extrn getchar : proc
extrn ExitProcess : proc

.data
    base       dq 3
    exponente  dq 4
    modulo     dq 5
    resultado  dq ?
    msg        db "Resultado: %d", 10, 0  ; 10 = salto de línea

.code
main PROC
    sub rsp, 40                     ; Reserva espacio y alinea pila (16 bytes)

    ; Llama a mod_exp(base, exp, mod)
    mov rcx, base                   ; 1er argumento (base)
    mov rdx, exponente              ; 2do argumento (exponente)
    mov r8, modulo                  ; 3er argumento (modulo)
    call mod_exp                    ; resultado queda en RAX

    mov resultado, rax

    ; Llamar a printf("Resultado: %d", resultado)
    lea rcx, msg                    ; RCX = dirección del formato
    mov rdx, rax                    ; RDX = resultado (entero)
    call printf

    call getchar                    ; Esperar tecla antes de salir

    mov ecx, 0
    call ExitProcess
main ENDP


; ------------------------------------------------------------
; PROCEDIMIENTO: mod_exp
; Calcula (base ^ exponente) mod m mediante exponenciación rápida
; Argumentos:
;   RCX = base
;   RDX = exponente
;   R8  = módulo
; Retorno:
;   RAX = resultado
; ------------------------------------------------------------
mod_exp PROC
    mov rax, 1                      ; result = 1
    mov rbx, rcx                    ; copia base
    mov rcx, rdx                    ; exponente
    mov r9,  r8                     ; módulo

ciclo_modexp:
    test rcx, rcx
    jz fin_modexp

    test rcx, 1
    jz base_cuadrado

    ; result = (result * base) % modulo
    mov rdx, 0
    mul rbx
    div r9
    mov rax, rdx

base_cuadrado:
    mov rdx, 0
    mov r10, rbx
    imul r10, rbx
    mov rbx, r10
    mov rdx, 0
    div r9
    mov rbx, rdx

    shr rcx, 1
    jmp ciclo_modexp

fin_modexp:
    ret
mod_exp ENDP

END

