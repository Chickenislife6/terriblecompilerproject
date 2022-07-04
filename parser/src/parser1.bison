%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "../expr.h"
    #define YYSTYPE struct block*
    int yylex();
    extern char* yytext;
    extern struct expr* expr_create(sent_t, struct expr*, struct expr*);
    extern struct expr* expr_create_value(int);
    extern struct decl* decl_create(sent_t, struct expr*, char*);
    extern struct block* block_create(sent_t);

    void yyerror(const char *s);
    struct block* parser_result;
%}
    %token TOKEN_EOF
    %token TOKEN_COMMENT
    %token TOKEN_END
    %token TOKEN_JUMP
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
    %token TOKEN_COLON
    %token TOKEN_ERROR
%%
prog : sentence TOKEN_RETURN { parser_result = $1; }
;
sentence: expr TOKEN_SEMI { $$ = $1; }
        | decl TOKEN_SEMI { 
            struct block* a = block_create(DECL);
            a->decl = $1->decl;
            $$ = a;
            }
        | statement TOKEN_SEMI { $$ = NULL; }
;
decl : ident TOKEN_COLON type TOKEN_EQUALITY expr { $$ = block_create(DECL); $$->decl = decl_create($3->type, $5->expr, $1->value);}
;
ident : TOKEN_IDENT { $$ = block_create(TYPE_STRING); $$->value = yytext; }
;
type : TOKEN_INT { $$ = block_create(TYPE_NUMBER); }
    | TOKEN_CHAR { $$ = block_create(TYPE_CHAR); }
    | TOKEN_STRING { $$ = block_create(TYPE_STRING); }
    | TOKEN_BOOLEAN { $$ = block_create(TYPE_BOOLEAN); }
;
statement : TOKEN_INT { $$ = NULL; }
;
expr : expr TOKEN_PLUS term { $$ = block_create(EXPR); $$->expr = expr_create(EXPR_ADD, $1->expr, $3->expr); }
    | expr TOKEN_MINUS term { $$ = block_create(EXPR); $$->expr = expr_create(EXPR_SUBTRACT, $1->expr, $3->expr); }
    | term { $$ = $1; }
;
term : term TOKEN_MUL factor {$$ = block_create(EXPR); $$->expr = expr_create(EXPR_MULTIPLY, $1->expr, $3->expr);}
    | term TOKEN_DIV factor { $$ = block_create(EXPR); $$->expr = expr_create(EXPR_DIVIDE, $1->expr, $3->expr);}
    | factor { $$ = $1; }
;
factor: TOKEN_MINUS factor { $$ = block_create(EXPR); $$->expr = expr_create(EXPR_SUBTRACT, expr_create_value(0), $2->expr); }
    | TOKEN_LPAREN expr TOKEN_RPAREN { $$ = $2; }
    | TOKEN_NUMBER { $$ = block_create(EXPR); $$->expr = expr_create_value(atoi(yytext)); }
;
%%
void yyerror(char const *s) {
   printf("%s\n", s);
}