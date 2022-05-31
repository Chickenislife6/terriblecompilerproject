%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "../expr.h"
    #define YYSTYPE struct expr*
    int yylex();
    extern char* yytext;
    extern struct expr* expr_create(expr_t, struct expr*, struct expr*);
    extern struct expr* expr_create_value(int);
    void yyerror(const char *s);
    struct expr* parser_result = 0;
%}
    %token TOKEN_EOF
    %token TOKEN_COMMENT
    %token TOKEN_INT
    %token TOKEN_CHAR
    %token TOKEN_STRING 
    %token TOKEN_BOOLEAN
    %token TOKEN_VOID
    %token TOKEN_ARRAY
    %token TOKEN_RETURN
    %token TOKEN_EQUALITY
    %token TOKEN_PLUS
    %token TOKEN_MINUS
    %token TOKEN_DIV
    %token TOKEN_MUL
    %token TOKEN_WHILE
    %token TOKEN_IF 
    %token TOKEN_ELSE
    %token TOKEN_TRUE
    %token TOKEN_FALSE
    %token TOKEN_FUNC
    %token TOKEN_FOR
    %token TOKEN_PRINT
    %token TOKEN_IDENT
    %token TOKEN_VALUE
    %token TOKEN_NUMBER
    %token TOKEN_SEMI
    %token TOKEN_LPAREN
    %token TOKEN_RPAREN
    %token TOKEN_LBRACKET
    %token TOKEN_RBRACKET
    %token TOKEN_ERROR
%%
prog : expr TOKEN_SEMI { parser_result = $1; }
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