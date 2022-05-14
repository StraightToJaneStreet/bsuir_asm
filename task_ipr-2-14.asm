use32
format PE Console

include 'win32ax.inc'

section '.idata' data import readable
  library kernel, 'kernel32.dll', msvcrt, 'msvcrt.dll'
  import kernel, exit, 'ExitProcess'
  import msvcrt, \
    printf, 'printf', \
    getch, '_getch', \
    scanf, 'scanf'

ARRAY_MAX_LEN = 10

section '.data' data readable writeable
  input_fmt db '%d', 0
  msg_input_n db 'N: ', 0
  msg_input_m db 'M: ', 0
  msg_input_arr_first  db 'First array:  ', 0
  msg_input_arr_second db 'Second array: ', 0
  output_fmt db 'Result: %d', 0
  n dd 0
  m dd 0
  arr_first  db ARRAY_MAX_LEN dup(0)
  arr_second db ARRAY_MAX_LEN dup(0)
  result dd 0


section '.code' code readable executable
  
  
  proc read_array stdcall uses eax ecx ebx, msg_in_len, msg_in_arr, count_ref, target_ref
    local len_ptr:DWORD, len:DWORD
    
    mov eax, dword [count_ref]
    mov dword [len_ptr], eax
    
    invoke printf, ptr msg_in_len
    invoke scanf, input_fmt, [len_ptr]
    invoke printf, ptr msg_in_arr
    
    mov ebx, [target_ref]
    mov eax, [len_ptr]  
    mov ecx, [eax]
    mov [len], ecx
    
    read_array_loop:
      mov eax, [len]
      sub eax, ecx
      add eax, ebx
      push ecx
      invoke scanf, dword input_fmt, eax
      add esp, 8
      pop ecx  
    loop read_array_loop
    ret
  endp
  proc find_count uses eax ebx ecx, k, count, arr
    mov ecx, [count]
    find_count_loop:
      mov eax, [count]
      sub eax, ecx
      add eax, [arr]
      mov ebx, 0
      mov bl, [eax]
      sub ebx, [k]
      je inc_counter
      jmp continue
      inc_counter:
        add [result], 1
      continue:
    loop find_count_loop
    ret
  endp
  
  entry $
  
  stdcall read_array, \
      msg_input_n, msg_input_arr_first, \
      n, arr_first
      
  stdcall read_array, \
      msg_input_m, msg_input_arr_second, \
      m, arr_second
      
  mov ecx, [n]
  
  main_loop:
    mov eax, [n]
    sub eax, ecx
    add eax, arr_first
    mov ebx, 0
    mov bl, [eax]
    stdcall find_count, ebx, [m], arr_second
  loop main_loop

  invoke printf, output_fmt, [result]
  invoke getch
  invoke exit, 0
