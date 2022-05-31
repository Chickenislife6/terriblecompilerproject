%{
    #include <stdio.h>
    int yylex();
    void yyerror(const char *s);
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
program : expr TOKEN_SEMI;
expr : expr TOKEN_PLUS term
| expr TOKEN_MINUS term
| term
| TOKEN_EOF
;
term : term TOKEN_MUL factor
| term TOKEN_DIV factor
| factor
;
factor: TOKEN_MINUS factor
| TOKEN_LPAREN expr TOKEN_RPAREN
| TOKEN_NUMBER
;
%%
void yyerror(char const *s) {
   printf("%s\n", s);
}