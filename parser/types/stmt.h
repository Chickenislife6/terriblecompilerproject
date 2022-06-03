
typedef enum {
    STMT_DECL,
    STMT_ENUM,
    STMT_STATEMENT,
    STMT_IF,
    STMT_FOR,
    STMT_ELSE,
    STMT_FUNCTION,
    STMT_RETURN,
    STMT_PRINT
} stmt_t;

struct stmt {
    stmt_t type;
    struct decl* decl_value;
    struct expr* expr_value;
    char* identifier;
    struct stmt* body;
    struct stmt* else_body;
    struct stmt* next;
};