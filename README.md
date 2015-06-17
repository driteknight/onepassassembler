# One Pass Assembler
One Pass Assembler using Lex and Yacc for Microprocessor 8086

Goto folder src. Run the script compile.sh with the file name

Example : ./compile.sh Tests/prog1.asm

Tests folder contains examples test files.

Output -> Displayed on terminal and object code is in assembly_code.obj


Files:
include.h -> contains necessary functions to create the object code.
pass1.y -> Yacc file having the grammar
proj.l -> Lex file
newoptable.txt -> Optable -> contains the list of commands
symtab.txt -> Symbol Table
