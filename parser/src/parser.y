%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "../impl/decl.c"
    #include "../impl/expr.c"
    #include "../impl/stmt.c"
    #include "../impl/stmt_table.c"
    #include <string.h>
    int yylex();
    struct table old_table = {0, 0};
    struct table* table = &old_table;

    extern char* yytext;
    extern int yyleng;
    extern int current_line;
    extern struct expr* expr_create(expr_t, struct expr*, struct expr*);
    extern struct expr* expr_create_value(int);
    extern struct expr* expr_create_ident(char*);
    extern struct decl* decl_create(char*, type_t, int, char, char*, int, struct expr*);
    extern struct stmt* stmt_create(stmt_t, struct decl*, struct expr*, struct stmt*);
    extern struct stmt* if_create(struct stmt*, struct stmt*, struct stmt*, struct expr*);
    extern struct stmt* print_create(stmt_t, char*);
    extern struct table* add_entry(struct table*, struct decl*);
    extern struct table* create_table(struct decl*);
    extern int check_type(struct expr*, type_t, struct table*);
    extern type_t get_type(struct table*, char*);

    void yyerror(const char *s);
    struct stmt* parser_result = 0;

    char* copy_yytext(char* text) {
        char* return_text = malloc(sizeof(char)*yyleng);
        strcpy(return_text, text);
        return return_text;
    }

    char* alter_yystring(char* text) {    
        char* return_text = malloc(sizeof(char)*(yyleng-2));
        strcpy(return_text, text+1);
        return_text[strlen(return_text)-1] = '\0';
        printf("\rmemcpy'd: %s\r", return_text);
        return return_text;
    }
%}
    %union { 
        struct stmt* stmt_ptr;
        struct expr *expr_ptr;
        struct decl *decl_ptr;
        int i;
        char* c;
    }
    %token <expr_ptr> TOKEN_EOF
    %token <expr_ptr> TOKEN_COMMENT
    %token <expr_ptr> TOKEN_END
    %token <expr_ptr> TOKEN_JUMP
    %token <expr_ptr> TOKEN_INT
    %token <expr_ptr> TOKEN_CHAR
    %token <expr_ptr> TOKEN_STRING 
    %token <expr_ptr> TOKEN_BOOLEAN
    %token <expr_ptr> TOKEN_VOID
    %token <expr_ptr> TOKEN_ARRAY
    %token <expr_ptr> TOKEN_RETURN
    %token <expr_ptr> TOKEN_ASSIGN
    %token <expr_ptr> TOKEN_PLUS
    %token <expr_ptr> TOKEN_MINUS
    %token <expr_ptr> TOKEN_DIV
    %token <expr_ptr> TOKEN_MUL
    %token <expr_ptr> TOKEN_EQUALITY
    %token <expr_ptr> TOKEN_LT
    %token <expr_ptr> TOKEN_GT
    %token <expr_ptr> TOKEN_WHILE
    %token <expr_ptr> TOKEN_IF 
    %token <expr_ptr> TOKEN_ELSE
    %token <expr_ptr> TOKEN_TRUE
    %token <expr_ptr> TOKEN_FALSE
    %token <expr_ptr> TOKEN_FUNC
    %token <expr_ptr> TOKEN_FOR
    %token <expr_ptr> TOKEN_PRINT
    %token <expr_ptr> TOKEN_IDENT
    %token <expr_ptr> TOKEN_VALUE
    %token <expr_ptr> TOKEN_NUMBER
    %token <expr_ptr> TOKEN_SEMI
    %token <expr_ptr> TOKEN_COLON
    %token <expr_ptr> TOKEN_LPAREN
    %token <expr_ptr> TOKEN_RPAREN
    %token <expr_ptr> TOKEN_LBRACKET
    %token <expr_ptr> TOKEN_RBRACKET
    %token <expr_ptr> TOKEN_ERROR
    %type <expr_ptr> expr term factor comparison
    %type <c> ident
    %type <i> type
    %type <decl_ptr> decl value
    %type <stmt_ptr> sentence2 prog sentence if_statement function statement
%%
prog : sentence TOKEN_EOF {  printf("prog "); parser_result = $1; }
;
sentence : sentence sentence2 TOKEN_SEMI { printf("expanded "); chain_stmt($1, $2); $$ = $1; }
        | sentence2 TOKEN_SEMI { printf("nothin "); $$ = $1; }
;
sentence2 : decl  { printf("DECL %s", $1->name); 
                if ($1->type == EXPR) {
                    if (!check_type($1->expr_value, EXPR, table)) {
                        yyerror("(DECL) the variable on the right is not equal in type to the left ");
                    }
                }
                // add something that checks the table for the name and type if identifier exists and emits errors if type doens't match up
                $$ = stmt_create(STMT_DECL, $1, NULL, NULL); 
                add_entry(table, $1); } 
        | statement { $$ = $1; }
        | expr  { printf("EXPR "); 
            $$ = stmt_create(STMT_ENUM, NULL, $1, NULL);  
            }
        | if_statement { $$ = $1; }
        | function { $$ = $1;  } // currently only print
;
function : TOKEN_PRINT TOKEN_LPAREN ident TOKEN_RPAREN { printf("print statement: %s ", $3); $$ = print_create(STMT_PRINT, $3);}
;
if_statement : TOKEN_IF TOKEN_LPAREN expr TOKEN_RPAREN TOKEN_LBRACKET sentence TOKEN_RBRACKET { printf("if matched"); 
        if (!check_type($3, EXPR, table)) {
            yyerror("(EXPR) the variable on the right is not equal in type to the left ");
        }
        $$ = if_create(NULL, NULL, $6, $3);}
;
decl : ident TOKEN_COLON type TOKEN_ASSIGN value { 
    $$ = decl_create($1, $3, $5->int_value, $5->char_value, $5->str_value, $5->bool_value, $5->expr_value);
    switch ($3) {
        case EXPR:
            if ($5->type != EXPR) {yyerror("GIVEN TYPE IS NOT EXPR"); }
            break;
        case STRING:
            if ($5->type != STRING) {yyerror("GIVEN TYPE IS NOT STRING");}
            break;
        case CHAR:
            if ($5->type != STRING) {yyerror("GIVEN TYPE IS NOT A STRING");}
            break;
        case BOOLEAN:
            if ($5->type != BOOLEAN) {yyerror("GIVEN TYPE IS NOT A BOOLEAN");}
            break;
    }}
;
ident : TOKEN_IDENT { printf("%s ", yytext); $$ =  copy_yytext(yytext); }
;
type : TOKEN_INT { $$ = EXPR;  }
    | TOKEN_STRING { $$ = STRING; }
    | TOKEN_CHAR { $$ = CHAR; }
    | TOKEN_BOOLEAN { $$ = BOOLEAN; }
    /* | TOKEN_ARRAY { } */
;
value : TOKEN_VALUE { $$ = decl_create("", STRING, 0, 0, alter_yystring(yytext), 0, NULL); }
    // add char
    | TOKEN_TRUE {  $$ = decl_create("", BOOLEAN, 0, 0, 0, 1, NULL); }
    | TOKEN_FALSE {$$ = decl_create("", BOOLEAN, 0, 0, 0, 0, NULL); }
    | expr { $$ = decl_create("", EXPR, 0, 0, 0, 0, $1); }
;
statement: TOKEN_JUMP { $$ = stmt_create(STMT_JUMP, NULL, NULL, NULL);}
;
expr : expr TOKEN_PLUS term { $$ = expr_create(EXPR_ADD, $1, $3); }
    | expr TOKEN_MINUS term { $$ = expr_create(EXPR_SUBTRACT, $1, $3); }
    | term { $$ = $1; }
;
term : term TOKEN_MUL comparison { $$ = expr_create(EXPR_MULTIPLY, $1, $3); }
    | term TOKEN_DIV comparison { $$ = expr_create(EXPR_DIVIDE, $1, $3); }
    | comparison { $$ = $1; }
;
comparison : comparison TOKEN_LT factor { $$ = expr_create(EXPR_LT, $1, $3); }
            | comparison TOKEN_GT factor { $$ = expr_create(EXPR_GT, $1, $3); }
            | comparison TOKEN_EQUALITY factor { $$ = expr_create(EXPR_EQUAL, $1, $3); }
            | factor { $$ = $1; }
;
factor: TOKEN_MINUS factor { $$ = expr_create(EXPR_SUBTRACT, expr_create_value(0), $2); }
    | TOKEN_LPAREN expr TOKEN_RPAREN { $$ = $2; }
    | TOKEN_NUMBER { $$ = expr_create_value(atoi(yytext)); }
    | ident { $$ = expr_create_ident( copy_yytext(yytext) ); }
;
%%
void yyerror(char const *s) {
   printf("\n%s", s);
   printf("failed on line: %u \n", current_line);
}

int check_type(struct expr* e, type_t type, struct table* table) {
    if (!e) {
        return 1;
    }
    if ((e->kind == EXPR_IDENT) && (get_type(table, e->name) != type)) {
        return 0;
    }
    return (check_type(e->left, type, table) && check_type(e->right, type, table));
}