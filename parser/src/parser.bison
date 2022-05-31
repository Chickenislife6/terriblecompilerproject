%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex();
    extern char* yytext;
    void yyerror(const char *s);
    int parser_result = 0;
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
expr : expr TOKEN_PLUS term { $$ = $1 + $3; }
    | expr TOKEN_MINUS term { $$ = $1 - $3; }
    | term { $$ = $1; }
;
term : term TOKEN_MUL factor { $$ = $1 * $3; }
    | term TOKEN_DIV factor { $$ = $1 / $3; }
    | factor { $$ = $1; }
;
factor: TOKEN_MINUS factor { $$ = -$2; }
    | TOKEN_LPAREN expr TOKEN_RPAREN { $$ = $2; }
    | TOKEN_NUMBER { $$ = atoi(yytext); }
;
%%
void yyerror(char const *s) {
   printf("%s\n", s);
}