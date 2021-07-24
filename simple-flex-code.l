/* File name:       simple-flex-code.l
   
	flex -o simple-flex-code.c simple-flex-code.l
        gcc -o simple-flex-code simple-flex-code.c
        ./simple-flex-code
*/





%option noyywrap
%x C_COMMENT   
%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#include "token.h"


int line = 1;
int C_COMMENT;   /*δήλωση C_COMMENT variable για τη διαχείριση των σχολίων */
 

%}


KEYWORD	("int")|("if")|("else")|("while")|("do")|("break")|("continue")|("double")|("float")|("return")|("case")|("sizeof")|("long")|("short")|("switch")|("void")|("struct")|("func")|("const")|("for")

OPERATOR	"="|"+"|"-"|"*"|"/"|"<="|">="|"++"|"!="|"=="|"<"|">"|"%"|"+="|"-="|"*="|"/="|"!"|"&&"|"||"|"--"|"&"   

DELIMITER	[ \t]+  

INTEGER        [1-9]+[0-9]*|0[x|X][0-9A-F]+|0[0-7]+|0

FLOAT		[0-9]+[.][0-9]+[e|E][0-9]+|[0-9]+[.][0-9]+|[0-9]+[e|E][0-9]+

STRING	["][\w\s]*.*[^\n\"]["]

IDENTIFIER	[a-zA-Z_][a-zA-Z_0-9]*

ONE_LINE_COMMENTS	[/][/]+.*

WHITESPACE	[\s]


%%

{KEYWORD}	{return KEYWORD;}
{OPERATOR}	{return OPERATOR;}
{DELIMITER}     {return DELIMITER;}
{INTEGER}	{return INTEGER;}
{FLOAT}	{return FLOAT;}
{STRING}	{return STRING;}
{IDENTIFIER}	{return IDENTIFIER;}
{ONE_LINE_COMMENTS}	{}  
{WHITESPACE}	{}  
\n	{line++; printf("\n");}   
<<EOF>>	{printf("#END-OF-FILE#\n"); exit(0);}  
"/*"            {BEGIN(C_COMMENT);}   
<C_COMMENT>"*/" {BEGIN(0);}   
<C_COMMENT>\n   {}    
<C_COMMENT>.    {}    
.	{fprintf(yyout, "\tLine=%d,UNKNOWN ERROR, value=\"%s\"\n", line, yytext);}  
%%


char *tname[9] = {"KEYWORD","OPERATOR","DELIMITER","INTEGER","FLOAT","STRING","IDENTIFIER","ONE_LINE_COMMENTS","WHITESPACE"};

int main(int argc, char **argv){
        int token; 

        if(argc == 3){
                if(!(yyin = fopen(argv[1], "r"))) {
                        fprintf(stderr, "Cannot read file: %s\n", argv[1]);
                        return 1;
                }
                if(!(yyout = fopen(argv[2], "w"))) {
                        fprintf(stderr, "Cannot create file: %s\n", argv[2]);
                        return 1;
                }
        }
        else if(argc == 2){
                if(!(yyin = fopen(argv[1], "r"))) {
                        fprintf(stderr, "Cannot read file: %s\n", argv[1]);
                        return 1;
                }
        }

       

        while((token=yylex()) >= 0){
              
                fprintf(yyout, "\tLine=%d, token=%s, value=\"%s\"\n", line, tname[token-1], yytext);
                
        }
        return 0;
}
