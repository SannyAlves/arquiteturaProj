;UNIVERSIDADE FEDERAL DA PARAÍBA
;CURSO: ENGENHARIA DA COMPUTAÇÃO
;DISCIPLINA: ARQUITETURA DE COMPUTADORES
;PROFESSOR: EWERTON MONTEIRO SALVADOR
;EQUIPE: WALLISSON DANTAS DA SILVA - 11321924
;        SANNY ALVES DE SOUSA - 11324088
.386 

.model flat,stdcall 

option casemap:none 

include \masm32\include\windows.inc 
include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib  
includelib \masm32\lib\masm32.lib  

.data
msgBoasVindas db " Ola! Programa para calcular MDC entre dois numeros, ok?",0ah,0h
msgNumero1 db "Insira o primeiro numero: ",0h
msgNumero2 db " Insira o segundo numero: ",0h
msgFinal db " O MDC e: ",0h                                      ; 0h =\0 para string

varA dword ?
varB dword ?

consoleInHandle dword ?                                                        ;n inicializa a variavel
consoleOutHandle dword ?                                                       ;dword = 32bits sem sinal
stringEntrada db 5 dup(?)                                                      ; aloca 5 bytes nao inicializados
entradaConvertida db 5 dup(?)                                                  ; db = 1 byte
readCount dword ?                                                              ; n inicializa a variavel
writeCount dword ?                                                             ;converter
num dword ?                                                                    ;

.code 
start: 

invoke GetStdHandle, STD_OUTPUT_HANDLE      ;imprimir no console, Get..=identificador, STD...=parametro
mov consoleOutHandle, eax                   ; 

invoke GetStdHandle, STD_INPUT_HANDLE       ;                            
mov consoleInHandle, eax                    ;consoleInHeandle=eax

invoke WriteConsole, consoleOutHandle, addr msgBoasVindas, sizeof msgBoasVindas, addr writeCount, NULL

invoke WriteConsole, consoleOutHandle, addr msgNumero1, sizeof msgNumero1, addr writeCount, NULL
invoke ReadConsole, consoleInHandle, offset stringEntrada, sizeof stringEntrada, offset readCount, 0

	call converteEntrada                  
	invoke atodw, addr stringEntrada      
	mov varA, eax                        

invoke WriteConsole, consoleOutHandle, addr msgNumero2, sizeof msgNumero2, addr writeCount, NULL
invoke ReadConsole, consoleInHandle, offset stringEntrada, sizeof stringEntrada, offset readCount, 0

	call converteEntrada
	invoke atodw, addr stringEntrada
	mov varB, eax

	mov ecx,varA
      mov edx,varB   

    divide:
        mov varB,edx   ; 
        mov eax,ecx
        mov ecx,varB
        mov edx,0h
        div ecx       ; eax/ecx

        cmp edx,0h      ;compara o resto da divisao com zero
        jg divide       ;caso seja maior que 0, volta para divide


invoke dwtoa, varB, addr entradaConvertida
invoke WriteConsole, consoleOutHandle, addr msgFinal, sizeof msgFinal, addr writeCount, NULL                    ; printar na tela o resultado
invoke WriteConsole, consoleOutHandle, addr entradaConvertida, sizeof entradaConvertida, addr writeCount, NULL
invoke ExitProcess, 0

converteEntrada:
	mov esi, offset stringEntrada
prox2:
     mov al, [esi]
     inc esi
     cmp al, 48 ; Menor que ASCII 48
     jl  feito2
     cmp al, 58 ; Menor que ASCII 58
     jl  prox2
feito2:
     dec esi
     xor al, al
     mov [esi], al
	 ret

end start