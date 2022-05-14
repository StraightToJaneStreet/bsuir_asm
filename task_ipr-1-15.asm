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
  
  invoke printf, msg_input
  invoke scanf, input_fmt, input_source

  invoke printf, output_fmt, input_source
  invoke getch
  invoke exit, 0

section '.data' data readable writeable
  msg_input db 'Source: ', 0
  input_fmt db '%s', 0
  output_fmt db 'Result: %s', 0
  
  input_source db 100 dup(2)



