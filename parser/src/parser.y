%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "../impl/decl.c"
    #include "../impl/expr.c"
    #include "../impl/stmt.c"
    #include <string.h>
    int yylex();
    extern char* yytext;
    extern int yyleng;
    extern struct expr* expr_create(expr_t, struct expr*, struct expr*);
    extern struct expr* expr_create_value(int);
    extern struct decl* decl_create(char*, type_t, int, char, char*, int);
    extern struct stmt* stmt_create(stmt_t, struct decl*, struct expr*, struct stmt*);
    void yyerror(const char *s);
    struct stmt* parser_result = 0;
    char* copy_yytext(char* text) {
        char* return_text = malloc(sizeof(char)*yyleng);
        strcpy(return_text, text);
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
    %token <expr_ptr> TOKEN_INT
    %token <expr_ptr> TOKEN_CHAR
    %token <expr_ptr> TOKEN_STRING 
    %token <expr_ptr> TOKEN_BOOLEAN
    %token <expr_ptr> TOKEN_VOID
    %token <expr_ptr> TOKEN_ARRAY
    %token <expr_ptr> TOKEN_RETURN
    %token <expr_ptr> TOKEN_EQUALITY
    %token <expr_ptr> TOKEN_PLUS
    %token <expr_ptr> TOKEN_MINUS
    %token <expr_ptr> TOKEN_DIV
    %token <expr_ptr> TOKEN_MUL
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
    %type <expr_ptr> expr term factor 
    %type <c> ident
    %type <i> type
    %type <decl_ptr> decl value
    %type <stmt_ptr> sentence2 prog sentence
%%
prog : sentence TOKEN_EOF {  printf("prog "); parser_result = $1; }
;
sentence : sentence sentence2 TOKEN_SEMI { printf("expanded "); $$ = stmt_create(STMT_STATEMENT, NULL, NULL, $2); }
        | sentence2 TOKEN_SEMI { printf("nothin "); $$ = $1; }
;
sentence2 : decl  { printf("DECL ", $1->name); $$ = stmt_create(STMT_DECL, $1, NULL, NULL);  } 
        | statement { }
        | expr  { printf("EXPR "); $$ = stmt_create(STMT_ENUM, NULL, $1, NULL);  }
;
decl : ident TOKEN_COLON type TOKEN_EQUALITY value { $$ = decl_create($1, $3, $5->int_value, $5->char_value, $5->str_value, $5->bool_value);}
;
ident : TOKEN_IDENT { $$ = copy_yytext(yytext); }
;
type : TOKEN_INT { $$ = INTEGER;  }
    | TOKEN_STRING { $$ = STRING; }
    | TOKEN_CHAR { $$ = CHAR; }
    | TOKEN_BOOLEAN { $$ = BOOLEAN; }
    /* | TOKEN_ARRAY { } */
;
value : TOKEN_NUMBER { $$ = decl_create("", INTEGER, atoi(yytext), 0, 0, 0);  }
    | TOKEN_VALUE { $$ = decl_create("", STRING, 0, 0, copy_yytext(yytext), 0); }
    // add char
    | TOKEN_TRUE {  $$ = decl_create("", BOOLEAN, 0, 0, 0, atoi(yytext)); }
    | TOKEN_FALSE {$$ = decl_create("", BOOLEAN, 0, 0, 0, atoi(yytext)); }
;
statement: expr { }
;
expr : expr TOKEN_PLUS term { $$ = expr_create(EXPR_ADD, $1, $3); }
    | expr TOKEN_MINUS term { $$ = expr_create(EXPR_SUBTRACT, $1, $3); }
    | term { $$ = $1; }
;
term : term TOKEN_MUL factor { $$ = expr_create(EXPR_MULTIPLY, $1, $3); }
    | term TOKEN_DIV factor { $$ = expr_create(EXPR_DIVIDE, $1, $3); }
    | factor { $$ = $1; }
;
factor: TOKEN_MINUS factor { $$ = expr_create(EXPR_SUBTRACT, expr_create_value(0), $2); }
    | TOKEN_LPAREN expr TOKEN_RPAREN { $$ = $2; }
    | TOKEN_NUMBER { $$ = expr_create_value(atoi(yytext)); }
;
%%
void yyerror(char const *s) {
   printf("%s\n", s);
}
