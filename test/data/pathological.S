/* pathological block comment?
 */

        .global _start

        .text

        .byte 'J, '\J, '", '\\, '\n, '\03, '\x0, '\X091, '\01', '\x01'

        .byte '\,, '", '\

# line comment
_start:
        mov $'\n , %al
        mov $'\n' , %al
        mov $'a, %al
        mov $'"'/*"*/,%al

        # line comment
        mov $'\", %al
        mov     $1, %rax
        mov     $1, %rdi /* block comment line 1
        line 2 */
        mov     $message, %rsi
        mov     $13, %rdx
        syscall

        mov     $60, %rax
        xor     %rdi, %rdi
        syscall

other:
        .ascii "Not beginning \" of a comment /*"

message:
        .ascii  "Hello, world\n"
