#include "temp/token.h"
#include <stdio.h>
#include <stdlib.h>
#include "expr.c"
extern FILE *yyin;
extern char *yytext;
extern int yylex();
extern int yyparse();
extern struct expr* expr_create(sent_t kind, struct expr *left, struct expr *right);
extern struct expr* expr_create_value(int);
extern struct block* parser_result;

int block_evaluate( struct block *e) {
    if(!e) return 0;
    switch(e->type) {
        case EXPR: return 1;
    }
}
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
    
    printf("%s", parser_result->decl->value);
}