#include "../types/decl.h"

struct decl *decl_create( char* name,
type_t type, 
int int_value,
char char_value,
char* str_value,
int bool_value, 
struct expr* expr_value) {
    struct decl *e = malloc(sizeof(*e));
    e->name = name;
    e->type = type;
    switch(type) {
        case STRING:
            // printf("string");
            e->str_value = str_value;
            break;
        case INTEGER:
            // printf("int");
            e->int_value = int_value;
            break;
        case CHAR:
            // printf("char");
            e->char_value = char_value;
            break;
        case BOOLEAN:
            // printf("boolean");
            e->bool_value = bool_value;
            break;
        case EXPR: 
            e->expr_value = expr_value; 
            break;
    }
    return e;
}

