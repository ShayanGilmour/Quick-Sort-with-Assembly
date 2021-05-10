# Quick sort algorithm implemented with Assembly
Supports negative numbers. Simply input the array; *No need to enter the length of the array*.
To run the program, simple put these 3 files in the same directory, and execute the following command: `nasm -f elf64 ./a.asm && ld -o ./a -e _start ./a.o&& ./a`

The main code is `a.asm`. File `in_out.asm` is for reading & writing numbers (In this code, it's only used for writing numbers).

### Sample I/O:
`-2 67 1009 -5 0 8 45`
`-5 -2 0 8 45 67 1009`
