SYS_EXIT  equ 1
SYS_WRITE equ 4
STDOUT    equ 1

section .data 
  num db "12345"
  len equ $ - num

section .bss
   res  resb 10   ; Buffer to store digits of the sum (up to 10 digits)
   digit_count resb 1  ; Variable to store the number of digits in the sum

section .text
   global _start

_start:
   ; Calculate sum
   xor eax, eax            ; Clear eax for sum
   mov esi, num            ; Pointer to the preloaded number
   mov ecx, len            ; Number of digits to process
loop1:
   movzx ebx, byte [esi]  ; Load digit into ebx
   sub ebx, '0'            ; Convert ASCII to decimal
   add eax, ebx            ; Add to sum
   inc esi                 ; Move to next digit
   loop loop1              ; Loop until all digits processed

   ; Convert sum to decimal digits and store them in the buffer
   mov edi, res            ; Pointer to the buffer
   mov ecx, 10             ; Maximum number of digits to generate

loop2:
   call divide_by_ten     ; Call divide by ten routine
   add dl, '0'            ; Convert remainder to ASCII
   dec edi                ; Move to the previous byte in the buffer
   mov [edi], dl          ; Store ASCII digit in buffer
   dec ecx                ; Decrement counter
   test eax, eax          ; Check if quotient is zero
   jnz loop2              ; If not zero, repeat the loop

   ; Store the number of digits in the buffer
  mov byte [digit_count], 10 ; Maximum number of digits

   ; Print the sum 
   mov eax, SYS_WRITE
   mov ebx, STDOUT
   mov ecx, edi           ; Address of the first digit in the buffer
   mov edx, 10            ; Number of bytes to print (maximum digits)
   int 0x80

   ; Exit the program
   mov eax, SYS_EXIT
   xor ebx, ebx 
   int 0x80

divide_by_ten:
   xor edx, edx        ; Clear edx for division
   mov ebx, 10         ; Divide by 10
   div ebx             ; Divide eax by 10, quotient in eax, remainder in edx
   ret
   
