#include "../types/stmt.h"

struct stmt *stmt_create( stmt_t type, 
struct decl* decl_value,
struct expr* expr_value,
struct stmt* next
) {
    struct stmt *e = malloc(sizeof(*e));
    e->type = type;
    e->decl_value = decl_value;
    e->expr_value = expr_value;
    e->next = next;
    return e;
}
