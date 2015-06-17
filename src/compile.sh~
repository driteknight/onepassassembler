#!/bin/bash
clear
cc includefile.h
yacc -d pass1.y
lex proj.l
cc lex.yy.c y.tab.c -ll
clear
./a.out $1
