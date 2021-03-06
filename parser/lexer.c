#include "temp/token.h"
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex();
extern char *yytext;
char* get_token_name(yytoken_kind_t t) {
    char* output = malloc(sizeof(char)*20);
        switch (t)
        {
        case TOKEN_COMMENT:
            output = "COMMENT";
            break;
        case TOKEN_INT:
            output = "INT";
            break;
        case TOKEN_CHAR:
            output = "CHAR";
            break;
        case TOKEN_STRING:
            output = "STRING";
            break;
        case TOKEN_BOOLEAN:
            output = "BOOL";
            break;
        case TOKEN_VOID:
            output = "VOID";
            break;
        case TOKEN_ARRAY:
            output = "ARRAY";
            break;
        case TOKEN_RETURN:
            output = "RETURN";
            break;
        case TOKEN_EQUALITY:
            output = "EQUALITY";
            break;
        case TOKEN_PLUS:
            output = "TOKEN_ADD";
            break;
        case TOKEN_MINUS:
            output = "TOKEN_MINUS";
            break;
        case TOKEN_DIV:
            output = "DIV";
            break;
        case TOKEN_MUL:
            output = "MUL";
            break;
        case TOKEN_WHILE:
            output = "TOKEN_WHILE";
            break;
        case TOKEN_IF:
            output = "TOKEN_IF";
            break;
        case TOKEN_ELSE:
            output = "ELSE";
            break;
        case TOKEN_FUNC:
            output = "TOKEN_FUNC";
            break;
        case TOKEN_FOR:
            output = "FOR";
            break;
        case TOKEN_IDENT:
            output = "TOKEN_IDENT";
            break;
        case TOKEN_VALUE:
            output = "TOKEN_VALUE";
            break;
        case TOKEN_NUMBER:
            output = "TOKEN_NUMBER";
            break;
        case TOKEN_SEMI:
            output = "TOKEN_SEMICOLON";
            break;
        case TOKEN_LPAREN:
            output = "TOKEN_LPAREN";
            break;
        case TOKEN_RPAREN:
            output = "TOKEN_RPAREN";
            break;
        case TOKEN_LBRACKET:
            output = "TOKEN_LBRACKET";
            break;
        case TOKEN_RBRACKET:
            output = "TOKEN_RBRACKET";
            break;
        case TOKEN_ERROR:
            output = "TOKEN_ERROR";
            break;
        default:
            break;
        }
    return output;
}

int main() {
    yyin = fopen("example.c","r");
    if(!yyin) {
        printf("could not open program.c!\n");
        return 1;
    }
    
    while(1) {
        yytoken_kind_t t = yylex();
        if(t==TOKEN_EOF) break;
        char* output = get_token_name(t);
        
        printf("token: %s text: %s\n", output, yytext);
    }
}