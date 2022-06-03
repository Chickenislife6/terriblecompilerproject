#include "temp/token.h"
#include <stdio.h>
#include <stdlib.h>
#include "types/decl.h"
#include "types/expr.h"
#include "types/stmt.h"
#include "types/stmt_table.h"
extern FILE *yyin;
extern char *yytext;
extern int yylex();
extern int yyparse();
// extern struct expr* expr_create(expr_t kind, struct expr *left, struct expr *right);
// extern struct expr* expr_create_value(int);
extern struct stmt* parser_result;
extern struct table* table;

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

void print_decl(struct decl* e) {
    printf("name: %s: ", e->name);
    switch(e->type) {
        case INTEGER:
            printf("int: %u \n", e->int_value);
            break;
        case STRING:
            printf("str: %s \n", e->str_value);
            break;
        case CHAR:
            printf("char: %s \n", e->char_value);
            break;
        case BOOLEAN:
            printf("bool: %u \n", e->bool_value);
            break;
        case EXPR:
            print_expr(e->expr_value);
            printf(" \n");      
            break; 
    }
}

void print_table( struct table* table) {
    if (!table) return;
    print_decl(table->entry);
    print_table(table->next);
}


void print_stmt(struct stmt* e) {
    if (!e) return;
    struct decl* value;
    switch(e->type) {
        case STMT_DECL: 
            value = e->decl_value;
            print_decl(value);
            break;
        case STMT_ENUM:
            print_expr(e->expr_value);
            break;
        case STMT_IF:
            printf("if ( ");
            print_expr(e->expr_value);
            printf(") {");
            print_stmt(e->body);
            printf("}");
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
        printf("all decls in a decl table");
        print_table(table);
    } else {
        printf("faliure");
    }
    printf("a");

}