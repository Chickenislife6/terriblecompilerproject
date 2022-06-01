%{
#include "token.h"
%}
DIGIT [0-9]
LETTER [a-zA-Z]
WHITESPACE [ |\t|\n]
%%
{WHITESPACE} /* skip whitespace */
\/\*\.\*\*\/ { return TOKEN_COMMENT; }
END/{WHITESPACE}* { return TOKEN_EOF; }
int/{WHITESPACE}* { return TOKEN_INT; }
char/{WHITESPACE}* { return TOKEN_CHAR; }
string/{WHITESPACE}* { return TOKEN_STRING; }
void/{WHITESPACE}* { return TOKEN_VOID; }
boolean/{WHITESPACE}* { return TOKEN_BOOLEAN; }
array/{WHITESPACE}* { return TOKEN_ARRAY; }
return/{WHITESPACE}* { return TOKEN_RETURN; }
\= { return TOKEN_EQUALITY; }
\+ { return TOKEN_PLUS; }
\- { return TOKEN_MINUS; }
\/ { return TOKEN_DIV; }
\* { return TOKEN_MUL; }
while { return TOKEN_WHILE; }
if { return TOKEN_IF; }
else { return TOKEN_ELSE; }
true { return TOKEN_TRUE; }
false { return TOKEN_FALSE; }
for/\( { return TOKEN_FOR; }
print/\( { return TOKEN_FOR; }
({LETTER}+)/\( { return TOKEN_FUNC; }
{LETTER}(({LETTER}|{DIGIT})*)/(({WHITESPACE}|\,:)*) { return TOKEN_IDENT; }
\"({DIGIT}|{LETTER}|[%: ])+\" { return TOKEN_VALUE; }
{DIGIT}+ { return TOKEN_NUMBER; }
\; { return TOKEN_SEMI; }
\( {return TOKEN_LPAREN; }
\) {return TOKEN_RPAREN; }
\{ {return TOKEN_LBRACKET; }
\} {return TOKEN_RBRACKET; }
\: {return TOKEN_COLON; }
. { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }
