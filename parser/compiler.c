#include "temp/token.h"
#include <stdio.h>
#include <stdlib.h>
#include "types/decl.h"
#include "types/expr.h"
#include "types/stmt.h"
#include "types/stmt_table.h"
#include "print_prototypes/printf_def.c"
#include "print_prototypes/function_postlude.c"
#include "print_prototypes/function_prelude.c"
#include "print_prototypes/end_program.c"
extern FILE *yyin;
extern char *yytext;
extern int yylex();
extern int yyparse();
// extern struct expr* expr_create(expr_t kind, struct expr *left, struct expr *right);
// extern struct expr* expr_create_value(int);
extern struct stmt* parser_result;
extern struct table* table;
extern char* printf_def;
extern char* function_prelude;
extern char* function_postlude;
extern char* end_program;
int string_counter = 0;
int label_counter = 0;
int registers[16] = {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0};

int register_getter() {
    int i = 0;
    while (registers[i] == 1) {
        ++i;
    }
    registers[i] = 1;
    return i;
}
int free_register(int i) {
    registers[i] = 0;
    return 1; // success
}
union info {
    char* a;
    int b;
};

extern union info get_info(struct table*, char*);
extern type_t get_type(struct table*, char*);

void print_expr( struct expr *e, FILE* ptr ){
    if(!e) return;
    print_expr(e->left, ptr);
    print_expr(e->right, ptr);
    switch(e->kind) {
        case EXPR_VALUE: fprintf(ptr, "\t.long %u\n", e->value); break;
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

}

int print_expr_if( struct expr *e, FILE* ptr ){
    if(!e) return -1; 
    switch(e->kind) {
        case EXPR_VALUE: {
            int a = register_getter();
             fprintf(ptr, "\tmovq $%u, %%r%u\n", e->value, a);
             return a;
        }
        case EXPR_IDENT: {
            int a = register_getter();
            fprintf(ptr, "\tmovq %s(%%rip), %%r%u\n", e->name, a);
            return a;
        }
        case EXPR_ADD: { 
            int a = register_getter();
            int r1 = print_expr_if(e->left, ptr);
            int r2 = print_expr_if(e->right, ptr);
            fprintf(ptr, "\taddl %%r%u, %%r%u\n", r1, r2); 
            fprintf(ptr, "\tmovq %%r%u, %%r%u\n", r2, a);
            free_register(r1);
            free_register(r2);
            return a;
        }
        case EXPR_SUBTRACT: printf("- "); {
            int a = register_getter();
            int r1 = print_expr_if(e->left, ptr);
            int r2 = print_expr_if(e->right, ptr);
            fprintf(ptr, "\tsubq %%r%u, %%r%u\n", r1, r2); 
            fprintf(ptr, "\tmovq %%r%u, %%r%u\n", r2, a);
            free_register(r1);
            free_register(r2);
            return a;
        }
        case EXPR_MULTIPLY: printf("* "); break;
        case EXPR_DIVIDE: printf("/ "); break;
        case EXPR_LT: printf("< "); break;
        case EXPR_GT: {
            int a = register_getter();
            int r1 = print_expr_if(e->left, ptr);
            int r2 = print_expr_if(e->right, ptr);
            fprintf(ptr, "\tcmpq %%r%u, %%r%u\n", r1, r2); 
            free_register(r1);
            free_register(r2);
            return a;
        }
        case EXPR_EQUAL: printf("== "); break;
        return;
    }
}

void print_decl(struct decl* e, FILE* ptr) {
        if (e->type==(BOOLEAN||EXPR)) {

        }
    switch(e->type) {
        case INTEGER:
            printf("int: %u \n", e->int_value);
            break;
        case STRING:
            fprintf(ptr, "\t.globl %s\n"
                        "\t.section .rdata,\"dr\"\n"
                        ".LC%u:\n"
                        "\t.ascii \"%s\\0\"\n"
                        "\t.data\n"
                        "\t.align 8\n"
                        "%s:\n"
                        "\t.quad .LC%u\n", 
                        e->name, string_counter, e->str_value, e->name, string_counter);
            string_counter++;
            
            break;
        case CHAR:
            printf("char: %s \n", e->char_value);
            break;
        case BOOLEAN:
            fprintf(ptr, "\t.data\n"
                        "\t.globl %s\n"
                        "\t.align 4\n"
                        "%s:\n"
                        "\t.long %u\n",
                        e->name, e->name, e->bool_value);
            break;
        case EXPR:
            fprintf(ptr, "\t.data\n"
                        "\t.globl %s\n"
                        "\t.align 4\n"
                        "%s:\n",
                        e->name, e->name);
            print_expr(e->expr_value, ptr);
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
    struct expr* value;
    switch(e->type) {
        case STMT_DECL: 
            // value = e->decl_value;
            // print_decl(value, NULL); // make null
            break;
        case STMT_ENUM:
            // print_expr_if(e->expr_value, ptr);
            break;
        case STMT_JUMP:
            fprintf(ptr, "\tjmp .L%u\n", label_counter-1);
            break;
        case STMT_IF:
            value = e->expr_value;
            print_expr_if(e->expr_value, ptr);
            int curr_label = label_counter; ++label_counter;
            fprintf(ptr, "\tjl .L%u\n", curr_label);
            print_stmt(e->body, ptr);
            fprintf(ptr, ".L%u:\n", curr_label);
            print_stmt(e->next, ptr);
            break;
        case STMT_PRINT:
            fprintf(ptr, "\tmovq %s(%%rip), %%rcx\n", e->identifier);
            fprintf(ptr, "\tcall printf\n");
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

int add_prelude(char* name, FILE* ptr) {
    fprintf(ptr, printf_def);
}
int add_function(char* name, FILE* ptr) {
    fprintf(ptr, function_prelude, name, name, name, name);
}
int close_function(FILE* ptr) {
    fprintf(ptr, function_postlude);
}
int program_end(FILE* ptr) {
    fprintf(ptr, end_program);
}
const unsigned char UNICODE_BOM[3] = {0xEF, 0xBB, 0xBF};
int main() {
    char* file_name = "compiled.s";
    FILE *ptr = fopen(file_name,"w");
    yyin = fopen("example.c","r");
    if(!yyin) {
        printf("could not open example.c!\n");
        return 1;
    }
    if(yyparse() == 0) {
        printf("success!");
        add_prelude(file_name, ptr);
        print_table(table, ptr);
        add_function("main", ptr);
        // print_stmt(parser_result, ptr);
        print_stmt(parser_result, ptr);
        close_function(ptr);
        program_end(ptr);
    } else {
        printf("faliure");
    }
    printf("program end");
    
}