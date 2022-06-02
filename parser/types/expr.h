
typedef enum {
    EXPR_ADD,
    EXPR_SUBTRACT,
    EXPR_DIVIDE,
    EXPR_MULTIPLY,
    EXPR_VALUE,
    EXPR_IDENT,
    EXPR_LT,
    EXPR_GT,
    EXPR_EQUAL
} expr_t;

struct expr {
    expr_t kind;
    struct expr *left;
    struct expr *right;
    int value;
    char* name;
};