/* Onoma arxeiou:       simple-flex-code.l
   Perigrafh:           Ypodeigma gia anaptyksh lektikou analyth me xrhsh tou ergaleiou Flex
   Syggrafeas:          Ergasthrio Metaglwttistwn, Tmhma Mhxanikwn Plhroforikhs kai Ypologistwn,
                        Panepisthmio Dytikhs Attikhs
   Sxolia:              To paron programma ylopoiei (me th xrhsh flex) enan aplo lektiko analyth
			pou anagnwrizei kena (space kai tab) kai akeraious (dekadikou systhmatos
			mono!) gia th glwssa Uni-C enw diaxeirizetai tous eidikous xarakthres
			neas grammhs '\n' (new line) kai 'EOF' (end of file). Yparxoun anafores
			gia thn anagnwrish metablhtwn, me ton pragmatiko kwdika na exei antikatastathei
			apo to lektiko FILL ME wste na symplhrwthei apo esas. Proairetika o lektikos
			analyths dexetai orismata arxeiwn gia eisodo kai eksodo.
   Odhgies ekteleshs:   Dinete "make" xwris ta eisagwgika ston trexonta katalogo. Enallaktika:
			flex -o simple-flex-code.c simple-flex-code.l
                        gcc -o simple-flex-code simple-flex-code.c
                        ./simple-flex-code
*/

/* H anagnwsh periorizetai se ena mono arxeio kai termatizei sto prwto EOF */


/* Kwdikas C gia orismo twn apaitoumenwn header files kai twn metablhtwn.
   Otidhpote anamesa sta %{ kai %} metaferetai autousio sto arxeio C pou
   tha dhmiourghsei to Flex. */
%option noyywrap
%x C_COMMENT   
%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Header file pou periexei lista me ola ta tokens */
#include "token.h"

/* Orismos metrhth trexousas grammhs */
int line = 1;
int C_COMMENT;   /*δήλωση C_COMMENT variable για τη διαχείριση των σχολίων */
 

%}


/* Onomata kai antistoixoi orismoi (ypo morfh kanonikhs ekfrashs).
   Meta apo auto, mporei na ginei xrhsh twn onomatwn (aristera) anti twn,
   synhthws idiaiterws makroskelwn kai dysnohtwn, kanonikwn ekfrasewn */

 /*δήλωση regex για τα keywords*/
KEYWORD	("int")|("if")|("else")|("while")|("do")|("break")|("continue")|("double")|("float")|("return")|("case")|("sizeof")|("long")|("short")|("switch")|("void")|("struct")|("func")|("const")|("for")
 /*δήλωση regex για τους operators*/
OPERATOR	"="|"+"|"-"|"*"|"/"|"<="|">="|"++"|"!="|"=="|"<"|">"|"%"|"+="|"-="|"*="|"/="|"!"|"&&"|"||"|"--"|"&"   
/*δήλωση regex για τους διαχωριστές*/
DELIMITER	[ \t]+  
/*δήλωση regex για τους ακέραιους δεκαδικούς*/
INTEGER        [1-9]+[0-9]*|0[x|X][0-9A-F]+|0[0-7]+|0
/*δήλωση regex για τους αριθμούς κινούμενης υποδιαστολής και πράξεις με ύψωση σε δύναμη*/
FLOAT		[0-9]+[.][0-9]+[e|E][0-9]+|[0-9]+[.][0-9]+|[0-9]+[e|E][0-9]+
/*δήλωση regex για τα λεκτικά κυριολεκτικά*/
STRING	["][\w\s]*.*[^\n\"]["]
/*δήλωση regex για τα αναγνωριστικά*/
IDENTIFIER	[a-zA-Z_][a-zA-Z_0-9]*
/*δήλωση regex για τα σχόλια μίας γραμμής που ξεκινούν με // και μετά δέχονται οποιονδήποτε χαρακτήρα,αριθμό ή whitespace μία ή περισσότερες φορές*/ 
ONE_LINE_COMMENTS	[/][/]+.*
 /*δήλωση regex για τους whitespace χαρακτήρες*/
WHITESPACE	[\s]


/* Gia kathe pattern (aristera) pou tairiazei ekteleitai o antistoixos
   kwdikas mesa sta agkistra. H entolh return epitrepei thn epistrofh
   mias arithmhtikhs timhs mesw ths synarthshs yylex() */

%%

{KEYWORD}	{return KEYWORD;}
{OPERATOR}	{return OPERATOR;}
{DELIMITER}     {return DELIMITER;}
{INTEGER}	{return INTEGER;}
{FLOAT}	{return FLOAT;}
{STRING}	{return STRING;}
{IDENTIFIER}	{return IDENTIFIER;}
{ONE_LINE_COMMENTS}	{}  /*αν γραφτεί σχόλιο μίας γραμμής το αγνοεί και συνεχίζει κανονικά*/
{WHITESPACE}	{}   /*αν δεχτεί whitespace χαρακτήρα τον αγνοεί και συνεχίζει κανονικά*/
\n	{line++; printf("\n");}   /*όταν δεχτεί το χαρακτήρα new line αλλάζει γραμμή και αυξάνει το μετρητή των γραμμών κατά 1*/
<<EOF>>	{printf("#END-OF-FILE#\n"); exit(0);}  /*όταν φτάσει στο τέλος του αρχείου τυπώνει το αντίστοιχο μήνυμα και σταματάει την εκτέλεση*/ 
"/*"            {BEGIN(C_COMMENT);}   /*αν συναντήσει το /* ξεκινάει η εκτέλεση του κώδικα των σχολιών που ακολουθεί παρακάτω*/
<C_COMMENT>"*/" {BEGIN(0);}   /*αν συναντήσει αυτό το χαρακτήρα βγαίνει από την επανάληψη εκτέλεσης των σχολιών και ολοκληρώνεται*/
<C_COMMENT>\n   {}    /*αν δεχτεί το \n το αγνοεί και συνεχίζει να εκτελεί τον κώδικα των σχολίων*/
<C_COMMENT>.    {}    /*αν δεχτεί οποιονδήποτε άλλο χαρακτήρα τον αγνοεί και συνεχίζει να εκτελεί τον κώδικα των σχολίων*/
.	{fprintf(yyout, "\tLine=%d,UNKNOWN ERROR, value=\"%s\"\n", line, yytext);}   /*αν δεχτεί οποιονδήποτε άλλο χαρακτήρα εκτός από τους παραπάνω γράφει στο αρχείο τη γραμμή και την φράση που δέχτηκε καθώς και τη φράση UNKNOWN ERROR δηλώνοντας την μη αποδεκτή είσοδο*/
%%

/* Pinakas me ola ta tokens se antistoixia me tous orismous sto token.h */
char *tname[9] = {"KEYWORD","OPERATOR","DELIMITER","INTEGER","FLOAT","STRING","IDENTIFIER","ONE_LINE_COMMENTS","WHITESPACE"};


/* H synarthsh main: O kwdikas autos tha topotheththei autousios sto
   programma C pou tha dhmiourghsei to Flex kai tha apotelesei to arxiko
   shmeio ekteleshs ths efarmoghs tou lektikou analyth. */

int main(int argc, char **argv){
        int token;

        /* Ginetai o elegxos twn orismatwn ths grammhs entolwn. Ean ta
           orismata einai 3, to programma diabazei apo to arxeio tou 2ou
           orismatos kai grafei sto arxeio tou 3ou. Ean ta orismata einai
           2 diabazei apo to arxeio tou 2ou kai grafei sthn othonh.
           Ypenthymizetai oti to 1o orisma (argv[0]) sth C einai to onoma
           tou idiou tou ektelesimou arxeiou. */

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

        /* H synarthsh yylex diabazei xarakthres apo thn eisodo kai prospathei
           na angnwrisei tokens. Ta tokens pou anagnwrizei einai auta pou exoun
           oristei sto paron arxeio, anamesa sta %% kai %%. An o kwdikas pou
           antistoixei se kapoio pattern periexei thn entolh 'return TIMH', h
           yylex() epistrefei thn timh auth h opoia kai apothhkeyetai sth
           metablhth token. */

        while((token=yylex()) >= 0){
                /* Gia kathe token pou anagnwristhke, ektypwnetai h grammh pou auto
                   brethhke kathws kai to onoma tou mazi me thn timh tou. */
                fprintf(yyout, "\tLine=%d, token=%s, value=\"%s\"\n", line, tname[token-1], yytext);
                
        }
        return 0;
}
