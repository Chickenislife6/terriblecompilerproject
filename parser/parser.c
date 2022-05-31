#include "temp/token.h"
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern int yylex();
extern char *yytext;
extern int yyparse();
extern int parser_result;

int main() {
    yyin = fopen("example.c","r");
    if(!yyin) {
        printf("could not open example.c!\n");
        return 1;
    }

    if(yyparse() == 0) {
        printf("success!");
        printf("%u", parser_result);
    } else {
        printf("faliure");
    }
}