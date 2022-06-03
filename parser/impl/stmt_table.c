#include "../types/stmt_table.h"
#include<string.h>  
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

type_t get_type(struct table* table, char* name) {
    if (!(table->entry)) {
        return 0;
    }
    if (!strcmp((table->entry->name), name)) {
        return table->entry->type;
    }

    if((table->next)) {
        return get_type(table->next, name);
    }
    return 0;
}
