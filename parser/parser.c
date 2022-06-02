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

void print_expr( struct expr *e ){
    if(!e) return;
    print_expr(e->left);
    switch(e->kind) {
        case EXPR_VALUE: printf("%u ", e->value); break;
        case EXPR_ADD: printf("+ "); break;
        case EXPR_SUBTRACT: printf("- "); break;
        case EXPR_MULTIPLY: printf("* "); break;
        case EXPR_DIVIDE: printf("/ "); break;
        case EXPR_IDENT: printf("%s ", e->name); break;
        case EXPR_LT: printf("< "); break;
        case EXPR_GT: printf("> "); break;
        case EXPR_EQUAL: printf("== "); break;
        return;
    }
    print_expr(e->right);

}

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
                case EXPR:
                    print_expr(value->expr_value);      
                    break; 
            }
            printf("name: %s \n", value->name);
            break;
        case STMT_ENUM:
            print_expr(e->expr_value);
            break;
    }
    print_stmt(e->next);
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