format PE Console

include 'win32ax.inc'

section '.idata' data import readable
  library kernel, 'kernel32.dll', msvcrt, 'msvcrt.dll'
  import kernel, exit, 'ExitProcess'
  import msvcrt, \
    printf, 'printf', \
    getch, '_getch', \
    scanf, 'scanf'
                       
section '.code' code readable executable 
  entry $
  
  invoke print, msg_intro

  invoke printf, msg_in_a
  invoke scanf, input_fmt, a
  
  invoke printf, msg_in_b
  invoke scanf, input_fmt, b
  
  mov ax, cs       ; Указатель на текущий сегмент
  
  ; Готовим параметры для длинного возврата
  push eax         ; Добавляем на стек cs
  push dword .retp ; Добавлеем offset точки возврата после вызова
  
  ; Эмулируем длинный call длинным возвратом
  push eax         ; push cs 
  push solution     ; Добавляем адрес "вызываемой" функции
  
  ; Передаем аргументы через глобальные переменные
  mov [global_a], byte a
  mov [global_b], byte b
  
  retf ; Прдеставим что тут call cs:offset
  
  .retp: ; Точка возврата для retf

  mov [result], eax
  
  invoke printf, output_fmt, [result]
  invoke getch
  invoke exit, 0
      
section '.data' data readable writeable
  input_fmt db '%d', 0
  msg_into db 'Far call + global variables', 0
  msg_in_a db 'A: ', 0
  msg_in_b db 'B: ', 0
  output_fmt db 'Result: %d', 0
  a dd ?
  b dd ?
  global_a db ?
  global_b db ?
  result dd 0

section '.funcs' code readable executable
  proc  solution  far
    ; Кладём значения аргументов из регистов на стек
    local a:BYTE, b:BYTE, b16:WORD
    mov [a], [global_a] 
    mov [b], [global_b]
    
    ; Вычисляем A^2
    mov ah, 0
    mov [b16], ax
    mov al, [a]
    mul [a] 

    mov ecx, eax ; Сохраняем результат выполнения
    
    ; Вычисляем B^3
    mov al, [b]
    mul [b]
    mov dx, [b16] 
    mul dx
    shl edx, 16
    or eax, edx
    
    ; Вычисляем A^2 | B^3
    or eax, ecx
    
    mov eax, 0
    
    ; Снимаем со стека два WORD (BYTE + BYTE + WORD)
    pop ebx
    pop ebx
    
    ; Откатываемся на заранее лежащую в стеке точку возврата
    retf
  endp


