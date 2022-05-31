parser: lex.yy.o
	gcc parser.c lex.yy.o

lex.yy.o: lex.yy.c
	gcc lex.yy.c -c

lex.yy.c: scanner.lex
	flex scanner.lex

scanner.lex: