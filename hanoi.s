  .globl _start

  .data
  .set TOWER_ELEMS, 11
  .set TOWER_SIZE, 44
space:   .ascii " "
newline:   .ascii "\n"

  .text

  ##  zero the memory in a tower
init_tower:
  xor %rax, %rax                # zero %rax
  movl $11, %ecx
  rep stosw
  ret

print_one:
  mov %rdi, %rsi
  movl $1, %eax                 # SYS_write
  movl %eax, %edi               # fd = 1
  movl %eax, %edx               # n = 1
  syscall
  ret

print_space:
  push %rcx                     # save %rcx thru syscall
  call print_one
  mov $space, %rdi
  call print_one
  pop %rcx
  ret

print_newline:
  mov $newline, %rdi
  call print_one
  ret

print_tower:
  movl (%rdi), %ecx             # prepare to loop
  cmpl $0, %ecx
  jz finish_print_tower
  add $4, %rdi                  # point %rdi to data array
  sub $8, %rsp                  # allocate stack space
print_tower_loop:
  movl (%rdi), %eax             # copy int to %rax
  addl $'0', %eax               # turn %rax into ascii
  mov %rax, (%rsp)              # copy the int to the stack
  mov %rdi, %rbx                # save rdi to rbx
  mov %rsp, %rdi                # copy our into location to %rdi
  call print_space
  add $4, %rbx
  mov %rbx, %rdi
  loop print_tower_loop
  add $8, %rsp                  # deallocate stack space
finish_print_tower:
  call print_newline
  ret

print_all:
  lea -64(%rbp), %rdi
  call print_tower
  lea -128(%rbp), %rdi
  call print_tower
  lea -196(%rbp), %rdi
  call print_tower
  call print_newline
  ret

  ## Args: number of rings
solve:
  push %rdi
  mov %rsp, %rbp

  // S tower
  sub $64, %rsp
  mov %rsp, %rdi
  call init_tower

  // A tower
  sub $64, %rsp
  mov %rsp, %rdi
  call init_tower

  // D tower
  sub $64, %rsp
  mov %rsp, %rdi
  call init_tower

fill_tower:
  // initialize S tower
  lea -64(%rbp), %rax
  mov (%rbp),%rcx
  mov %rcx, (%rax)                # set the size of the tower
  add $4, %rax
init_s:
  mov %rcx, (%rax)
  add $4, %rax
  loop init_s

  // print the towers
  call print_all
  lea 8(%rbp), %rsp
  ret

_start:
  movl $3, %edi
  call solve

  mov $60, %rax                 # SYS_exit
  xor %rdi, %rdi
  syscall
