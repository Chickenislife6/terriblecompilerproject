lexer: temp/lex.yy.o
	gcc lexer.c temp/lex.yy.o

temp/lex.yy.o: temp/lex.yy.c
	gcc -o temp/lex.yy.o temp/lex.yy.c -c

temp/lex.yy.c: src/scanner.lex
	flex -otemp/lex.yy.c src/scanner.lex

src/scanner.lex:

parser: temp/parse.o temp/lex.yy.o
	gcc parser.c temp/parse.o temp/lex.yy.o -o parser.exe

temp/parse.o: temp/parse.c
	gcc -o temp/parse.o temp/parse.c -c

temp/parse.c: src/parser.y
	C:\Users\tyler\Desktop\bison\win_bison.exe --defines=temp/token.h --output=temp/parse.c src/parser.y

src/parser.y:
	