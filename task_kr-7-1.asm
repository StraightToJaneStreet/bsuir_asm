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

  invoke printf, msg_intro

  invoke printf, msg_in_a
  invoke scanf, input_fmt, a

  invoke printf, msg_in_b
  invoke scanf, input_fmt, b

  mov ax, cs

  push eax
  push dword .retp

  push eax
  push solution

  mov bx, word ptr a
  mov cx, word ptr b

  retf

  .retp:

  mov [result], eax

  invoke printf, output_fmt, [result]
  invoke getch
  invoke exit, 0

section '.data' data readable writeable
  input_fmt db '%d', 0
  msg_intro db 'Far call + register variables', 0dh, 0ah, 0
  msg_in_a db 'A: ', 0
  msg_in_b db 'B: ', 0
  output_fmt db 'Result: %d', 0
  a dw ?
  b dw ?
  result dd 0

section '.funcs' code readable executable
  proc  solution  far
    mov ax, cx
    mul ax
    shl edx, 16
    or eax, edx
    and eax, ebx
    add esp, 4
    retf
  endp


