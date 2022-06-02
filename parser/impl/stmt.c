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

struct stmt *if_create(struct stmt* next,
struct stmt* else_block,
struct stmt* body,
struct expr* comparison) {
    struct stmt *e = malloc(sizeof(*e));
    e->type = STMT_IF;
    e->else_body = else_block;
    e->body = body;
    e->next = next;
    e->expr_value = comparison;
    return e;
}

void chain_stmt(struct stmt* beg,
struct stmt* end) {
    if (beg->next) {
        chain_stmt(beg->next, end);
        return;
    }
    beg->next = end;
}