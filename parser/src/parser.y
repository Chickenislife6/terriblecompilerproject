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
        printf("test");
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
prog : sentence TOKEN_EOF {  printf("seoijretji "); parser_result = $1; }
;
sentence : sentence sentence2 TOKEN_SEMI { $$ = stmt_create(STMT_STATEMENT, NULL, NULL, $2); }
        | sentence2 TOKEN_SEMI { $$ = $1; }
;
sentence2 : decl  { printf("%s NAME \n", $1->name); $$ = stmt_create(STMT_DECL, $1, NULL, NULL);  } 
        | statement { }
        | expr  { printf("prog "); $$ = stmt_create(STMT_ENUM, NULL, $1, NULL);  }
;
decl : ident TOKEN_COLON type TOKEN_EQUALITY value { $$ = decl_create($1, $3, $5->int_value, $5->char_value, $5->str_value, $5->bool_value);}
;
ident : TOKEN_IDENT { printf("%s ident \n", yytext); $$ = copy_yytext(yytext); }
;
type : TOKEN_INT { printf("integer "); $$ = INTEGER;  }
    | TOKEN_STRING { printf("string "); $$ = STRING; }
    | TOKEN_CHAR { printf("char "); $$ = CHAR; }
    | TOKEN_BOOLEAN { printf("boolean "); $$ = BOOLEAN; }
    /* | TOKEN_ARRAY { } */
;
value : TOKEN_NUMBER { printf("number "); $$ = decl_create("", INTEGER, atoi(yytext), 0, 0, 0);  }
    | TOKEN_VALUE { printf("value "); $$ = decl_create("", STRING, 0, 0, copy_yytext(yytext), 0); }
    // add char
    | TOKEN_TRUE { printf("true "); $$ = decl_create("", BOOLEAN, 0, 0, 0, atoi(yytext)); }
    | TOKEN_FALSE { printf("false "); $$ = decl_create("", BOOLEAN, 0, 0, 0, atoi(yytext)); }
;
statement: expr { }
;
expr : expr TOKEN_PLUS term { $$ = expr_create(EXPR_ADD, $1, $3); printf("expr1 "); }
    | expr TOKEN_MINUS term { $$ = expr_create(EXPR_SUBTRACT, $1, $3); printf("expr2 ");}
    | term { $$ = $1; printf("expr3 ");}
;
term : term TOKEN_MUL factor { $$ = expr_create(EXPR_MULTIPLY, $1, $3); printf("term1 ");}
    | term TOKEN_DIV factor { $$ = expr_create(EXPR_DIVIDE, $1, $3); printf("term2 ");}
    | factor { $$ = $1; printf("term3 ");}
;
factor: TOKEN_MINUS factor { $$ = expr_create(EXPR_SUBTRACT, expr_create_value(0), $2); printf("a ");}
    | TOKEN_LPAREN expr TOKEN_RPAREN { $$ = $2; printf("b "); }
    | TOKEN_NUMBER { $$ = expr_create_value(atoi(yytext)); printf("c ");}
;
%%
void yyerror(char const *s) {
   printf("%s\n", s);
}
