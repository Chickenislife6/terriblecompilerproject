typedef enum {
EXPR_ADD,
EXPR_SUBTRACT,
EXPR_DIVIDE,
EXPR_MULTIPLY,
EXPR_VALUE
} expr_t;

typedef enum {
EXPR,
DECL,
STATEMENT,
TYPE_NUMBER,
TYPE_STRING,
TYPE_CHAR,
TYPE_BOOLEAN
} sent_t;

struct block {
sent_t type;
char *value;
struct expr *expr;
struct decl *decl;
struct block *next;
};

struct expr {
sent_t type;
expr_t kind;
struct expr *left;
struct expr *right;
int value;
};

struct code {
char* program;
};


struct decl {
char* name;
sent_t type;
struct expr *value;
};