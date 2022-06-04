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

union info {
    char* a;
    int b;
};

extern union info get_info(struct table*, char*);
extern type_t get_type(struct table*, char*);

void print_expr( struct expr *e, FILE* ptr ){
    if(!e) return;
    print_expr(e->left, ptr);
    switch(e->kind) {
        case EXPR_VALUE: fprintf(ptr, "   .long %u \n", e->value); break;
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
    print_expr(e->right, ptr);

}

void print_decl(struct decl* e, FILE* ptr) {
    printf("name: %s: ", e->name);
    if (ptr) {
        fprintf(ptr, "%s:\n", e->name);
    }
    switch(e->type) {
        case INTEGER:
            printf("int: %u \n", e->int_value);
            break;
        case STRING:
            fprintf(ptr, "    .ascii \"%s\\0\"\n  .data\n .align 8\n", e->str_value);
            break;
        case CHAR:
            printf("char: %s \n", e->char_value);
            break;
        case BOOLEAN:
            fprintf(ptr, "    .long 1%u \n", e->bool_value);
            break;
        case EXPR:
            print_expr(e->expr_value, ptr);
            printf(" \n");      
            break; 
    }
}

void print_table( struct table* table, FILE* ptr) {
    if (!table) return;
    print_decl(table->entry, ptr);
    print_table(table->next, ptr);
}


void print_stmt(struct stmt* e, FILE* ptr) {
    if (!e) return;
    struct decl* value;
    switch(e->type) {
        case STMT_DECL: 
            value = e->decl_value;
            print_decl(value, ptr); // make null
            break;
        case STMT_ENUM:
            print_expr(e->expr_value, ptr);
            break;
        case STMT_IF:
            printf("if ( ");
            print_expr(e->expr_value, ptr);
            printf(") {");
            print_stmt(e->body, ptr);
            printf("}");
            break;
        case STMT_PRINT:
            printf("print(");
            type_t type = get_type(table, e->identifier);
            switch (type) {
                case STRING:
                    printf("%s", get_info(table, e->identifier).a);
                    break;
                case BOOLEAN:
                    printf("%u", get_info(table, e->identifier).b);
                    break;
            }
            printf(")");
            break;
    }
    print_stmt(e->next, ptr);
}



int main() {
    FILE *ptr = fopen("compiled.txt","w");
    yyin = fopen("example.c","r");
    if(!yyin) {
        printf("could not open example.c!\n");
        return 1;
    }
    if(yyparse() == 0) {
        printf("success!");
        print_table(table, ptr);
        print_stmt(parser_result, ptr);
    } else {
        printf("faliure");
    }
    printf("program end");

}