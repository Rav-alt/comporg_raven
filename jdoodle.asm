section .data
    prompt1 db "Enter first number: ", 0
    prompt2 db "Enter second number: ", 0
    prompt3 db "Choose operation (+, -, *, /): ", 0
    resultMsg db "Result: ", 0
    newline db 10, 0
    invalid db "Invalid operation!", 10, 0

section .bss
    num1 resb 5
    num2 resb 5
    op resb 2
    result resb 10

section .text
    global _start

_start:
    ; Prompt for the first number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, 19
    int 0x80

    ; Read the first number
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 5
    int 0x80

    ; Convert first number
    mov ecx, num1
    call atoi
    mov esi, eax  ; Store first number

    ; Prompt for the second number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, 20
    int 0x80

    ; Read the second number
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 5
    int 0x80

    ; Convert second number
    mov ecx, num2
    call atoi
    mov edi, eax  ; Store second number

    ; Prompt for operation
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt3
    mov edx, 28
    int 0x80

    ; Read the operation
    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 2
    int 0x80

    ; Only consider first character of input
    mov al, [op]
    cmp al, '+'
    je add
    cmp al, '-'
    je sub
    cmp al, '*'
    je mul
    cmp al, '/'
    je div
    jmp invalid_op

add:
    add esi, edi
    jmp print_result

sub:
    sub esi, edi
    jmp print_result

mul:
    imul esi, edi
    jmp print_result

div:
    test edi, edi
    jz invalid_op  ; Avoid division by zero
    xor edx, edx   ; Clear remainder
    idiv edi
    jmp print_result

invalid_op:
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid
    mov edx, 19
    int 0x80
    jmp exit

print_result:
    mov eax, esi
    call itoa

    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, resultMsg
    mov edx, 8
    int 0x80

    ; Print result value
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Convert ASCII to integer
atoi:
    xor eax, eax
    xor ebx, ebx
atoi_loop:
    mov bl, byte [ecx]
    cmp bl, 10
    je atoi_done
    cmp bl, 0
    je atoi_done
    cmp bl, '0'
    jl atoi_skip
    cmp bl, '9'
    jg atoi_skip
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
atoi_skip:
    inc ecx
    jmp atoi_loop
atoi_done:
    ret

; Convert integer to ASCII
itoa:
    mov ecx, 0
    mov ebx, 10
itoa_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [result + ecx], dl
    inc ecx
    test eax, eax
    jnz itoa_loop

    ; Reverse result string
    mov eax, ecx
    xor ebx, ebx
itoa_reverse:
    dec eax
    cmp eax, ebx
    jle itoa_done
    mov dl, [result + eax]
    mov dh, [result + ebx]
    mov [result + eax], dh
    mov [result + ebx], dl
    inc ebx
    jmp itoa_reverse

itoa_done:
    mov byte [result + ecx], 0  ; Null terminate
    ret


segment .bss

    sum resb 1
