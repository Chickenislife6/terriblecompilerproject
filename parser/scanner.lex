%{
#include "token.h"
%}
DIGIT [0-9]
LETTER [a-zA-Z]
WHITESPACE [ |\t|\n]
%%
{WHITESPACE} /* skip whitespace */
\/\*\.\*\*\/ { return TOKEN_COMMENT; }
int { return TOKEN_INT; }
char { return TOKEN_CHAR; }
boolean { return TOKEN_BOOLEAN; }
\= { return TOKEN_EQUALITY; }
\+ { return TOKEN_ADD; }
\- { return TOKEN_MINUS; }
while { return TOKEN_WHILE; }
if { return TOKEN_IF; }
({LETTER}+)/\( { return TOKEN_FUNC; }
{LETTER}(({LETTER}|{DIGIT})*)/(({WHITESPACE}|\,)*) { return TOKEN_IDENT; }
\"({DIGIT}|{LETTER}|[%: ])+\" { return TOKEN_VALUE; }
{DIGIT}+ { return TOKEN_NUMBER; }
\; { return TOKEN_SEMICOLON; }
\( {return TOKEN_LPAREN; }
\) {return TOKEN_RPAREN; }
\{ {return TOKEN_LBRACKET; }
\} {return TOKEN_RBRACKET; }
. { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }