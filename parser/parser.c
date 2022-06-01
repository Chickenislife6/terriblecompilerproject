#include "temp/token.h"
#include <stdio.h>
#include <stdlib.h>
#include "types/decl.h"
#include "types/expr.h"
extern FILE *yyin;
extern char *yytext;
extern int yylex();
extern int yyparse();
// extern struct expr* expr_create(expr_t kind, struct expr *left, struct expr *right);
// extern struct expr* expr_create_value(int);
extern struct decl* parser_result;

int expr_evaluate( struct expr *e )
    {
    if(!e) return 0;
    int l = expr_evaluate(e->left);
    int r = expr_evaluate(e->right);
    switch(e->kind) {
    case EXPR_VALUE: return e->value;
    case EXPR_ADD: return l+r;
    case EXPR_SUBTRACT: return l-r;
    case EXPR_MULTIPLY: return l*r;
    case EXPR_DIVIDE:
    if(r==0) {
    printf("error: divide by zero\n");
    exit(1);
    }
    return l/r;
    }
    return 0;
    }

int main() {
    yyin = fopen("example.c","r");
    if(!yyin) {
        printf("could not open example.c!\n");
        return 1;
    }
    if(yyparse() == 0) {
        printf("success!");
    } else {
        printf("faliure");
    }
    printf("\n %s a\n", parser_result->name);
    printf("%s a\n", parser_result->str_value);
    printf("%u a\n", parser_result->type);
    printf("a");

}