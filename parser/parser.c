#include "temp/token.h"
#include <stdio.h>
#include <stdlib.h>
#include "types/decl.h"
#include "types/expr.h"
#include "types/stmt.h"
extern FILE *yyin;
extern char *yytext;
extern int yylex();
extern int yyparse();
// extern struct expr* expr_create(expr_t kind, struct expr *left, struct expr *right);
// extern struct expr* expr_create_value(int);
extern struct stmt* parser_result;

void print_stmt(struct stmt* e) {
    
    if (!e) return;
    struct decl* value;
    switch(e->type) {
        case STMT_DECL: 
            value = e->decl_value;
            switch(value->type) {
                case INTEGER:
                    printf("int value: %u \n", value->int_value);
                    break;
                case STRING:
                    printf("str value: %s \n", value->str_value);
                    break;
                case CHAR:
                    printf("char value: %s \n", value->char_value);
                    break;
                case BOOLEAN:
                    printf("bool value:%u \n", value->bool_value);
                    break;
            }
            printf("name: %s \n", value->name);; 
        case STMT_ENUM:
            printf("expr value: %u \n", e->expr_value);
            break;
        case STMT_STATEMENT:
            print_stmt(e->next);
            break;

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
        print_stmt(parser_result);
    } else {
        printf("faliure");
    }
    printf("a");

}