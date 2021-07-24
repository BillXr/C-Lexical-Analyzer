# C-Lexical-Analyzer
Lexical analyzer for C language

This repository contains code for lexic analyze of Uni-C language (practically same as C language) that identify tokens from input file and write the kind of token that it is in output file.

This analyzer identify numbers(integer,octal,hexadecimal and floats),variables,strings,comments(one and multiple line),delimiters,whitespaces,operators and keywords of c-language.

For everything except delimiters and comments the program identifies them and return their type,for delimiters and comments program just ignores them and for everything else it prints an error message.

For the operation there is also a header file for all tokens that used,helping the analyzer identify them.

In the main we read the parametres we used when call the program,if we have 3 parametres the program reads from input file and write to output file,else if we have 2 program reads from input file and prints results in the screen.As a remind the first parametre is always the program name.

In order to work properlly we called yylex function to read and identify every single token from input.

To make this project and test it i worked on linux machines with Ubuntu distribution (LTS 20.04).
