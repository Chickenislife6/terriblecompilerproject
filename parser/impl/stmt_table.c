#include "../types/stmt_table.h"

struct table* create_table(struct decl* decl) {
    struct table* e = malloc(sizeof(*e));
    e->entry=decl;
    e->next = NULL;
    return e;
}

struct table* add_entry(struct table* table, struct decl* decl) {
    printf("test1");
    if (!(table->entry)) {
    printf("test");
        table->entry = decl;
    }
    else if(!(table->next)) {
    printf("test2");
        struct table* next_table = create_table(decl);
        table->next = next_table;
    }
    else {
    printf("test3");
        add_entry(table->next, decl);
    }
    printf("test4");
    return table;
}

