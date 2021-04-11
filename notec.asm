; Naiwna wersja notecia

; Lista rozpoznawanych znaków:
; & 38
; * 42
; + 43
; - 45
; 0-9 48-57
; = 61
; A-F 65-70
; N 78
; W 87
; X 88
; Y 89
; Z 90
; ^ 94
; a-f 97-102
; g 103
; n 110
; | 124
; ~ 126

    %macro binary_op 1
        pop     r9
        pop     r8
        %1      r8, r9
        push    r8
    %endmacro

    global  notec
    extern  debug

    section .text
notec:
    ; argumenty:
    ;   edi - numer instancji notecia
    ;   rsi - char *calc (z zał. obliczenie jest poprawne)
    ;   r11  - początkowy adres wierzchołka stosu
    ;
    ; wyjście:
    ;   rax - wynik obliczenia (wartość na wierzchołku stosu)
    ;
    ; stan:
    ;   rsi  - wskaźnik na następny znak
    ;   r10d - {0, 1} tryb wczytywania liczby

    xor     r10d, r10d          ; ustaw tryb wczytywania cyfry
    mov     r11, rsp            ; zapisz początkowy wskaźnik stosu

next:
    movzx   edx, byte [rsi]     ; wczytaj następny znak
    inc     rsi                 ; przesuń wskaźnik na kolejny znak

rec_char:                       ; rozpoznaje wczytany znak
    ; TODO czy mogę zamiast kodu ASCII wpisać np. 'W'?
    test    edx, edx    ; \0
    jz      exit
    cmp     edx, 38     ; &
    je      case_and
    cmp     edx, 42     ; *
    je      case_mul
    cmp     edx, 43     ; +
    je      case_add
    cmp     edx, 45     ; -
    je      case_sub
    cmp     edx, 57     ; 0-9
    jle     digit_0_9
    cmp     edx, 61     ; =
    je      case_set_digit_mode
    cmp     edx, 70     ; A-F
    jle     digit_A_F
    cmp     edx, 78     ; N
    je      case_push_N
    cmp     edx, 87     ; W
    je      TODO
    cmp     edx, 88     ; X
    je      case_swap_two_on_top
    cmp     edx, 89     ; Y
    je      case_duplicate_top
    cmp     edx, 90     ; Z
    je      case_remove_top
    cmp     edx, 94     ; ^
    je      case_xor
    cmp     edx, 102    ; a-f
    jle     digit_a_f
    cmp     edx, 103    ; g
    je      case_call_debug
    cmp     edx, 110    ; n
    je      case_push_instance_number
    cmp     edx, 124    ; |
    je      case_or
    cmp     edx, 126    ; ~
    je      case_not

digit_0_9:
    sub     edx, 48
    jmp     case_digit
digit_A_F:
    sub     edx, 55
    jmp     case_digit
digit_a_f:
    sub     edx, 87
case_digit:
    ; edx - wartość cyfry w systemie szesnastkowym
    test    r10d, r10d        ; sprawdź tryb wczytywania
    jnz     _number_mode    ; tryb wczytywania liczby

                            ; tryb wczytywania cyfry
    push    rdx             ; wstaw nową cyfrę na stos
    mov     r10d, 1          ; przejdź w tryb wczytywania liczby
    jmp     next            ; kontynuuj wczytywanie

_number_mode:
    mov     rax, qword [rsp] ; odczytaj aktualną liczbę na stosie
    shl     rax, 4           ; "dopisz cyfrę do liczby"
    add     rax, rdx         ; - || -
    mov     [rsp], rax       ; zapisz zmodyfikowaną liczbę na stosie
    jmp     next             ; kontynuuj wczytywanie

case_and:
    binary_op and
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_mul:
    pop     rdx
    pop     rax
    mul     rdx     ; rax = rax * rdx
    push    rax
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_add:
    binary_op add
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_sub:
    binary_op sub
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_set_digit_mode:
    mov     r10d, 0
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_push_N:
    push    N
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_swap_two_on_top:
    pop     r9
    pop     r8
    push    r9
    push    r8
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_duplicate_top:
    mov     rax, qword [rsp]
    push    rax
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_remove_top:
    pop     r8
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_xor:
    binary_op xor
    push    r8
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_call_debug:
    mov     r8, rsp         ; save initial stack pointer
    push    rdi             ; zapisz numer instancji notecia
    push    rsi             ; zapisz wskaźnik na kolejny znak obliczenia
    push    r10             ; zapisz tryb wczytywania
    push    r11             ; zapisz początkowy wskaźnik stosu

    mov     rax, rsp
    and     rsp, -16        ; wyrównaj stos do 16 bajtów
    push    rax             ; zapisz wskaźnik stosu sprzed wyrównania

    mov     rdi, rsi        ; numer instancji notecia
    mov     rsi, r8         ; wierzchołek stosu notecia
    call    debug

    pop     r8          ; wczytaj wskaźnik stosu sprzed wyrównania
    mov     rsp, r8     ; przywróć wskaźnik stosu do stanu sprzed wyrównania

    pop     r11
    pop     r10
    pop     rsi
    pop     rdi
    sal     rax, 3      ; convert shift amount from number of 64bit words to bytes
    add     rsp, rax    ; move stack pointer by the value returned from call

    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_push_instance_number:
    push    rdi
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_or:
    binary_op   or
    push        r8
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

case_not:
    not     qword [rsp]
    mov     r10d, 0         ; przejdź w tryb wczytywania cyfry
    jmp     next             ; kontynuuj wczytywanie

TODO:
    ; TYMCZASOWE
    jmp     next

exit:
    mov     rax, qword [rsp]    ; zwróć wynik obliczenia
    mov     rsp, r11            ; przywróć stos
    ret