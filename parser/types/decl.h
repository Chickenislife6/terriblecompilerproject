typedef enum { 
    INTEGER,
    STRING, 
    CHAR,
    BOOLEAN,
    EXPR
} type_t;

struct decl { 
    char* name;
    type_t type;
    int int_value;
    char* str_value;
    char char_value;
    int bool_value;
    struct expr* expr_value;
};

