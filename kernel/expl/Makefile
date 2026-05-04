CC = gcc
CFLAGS = -g -fcommon -std=gnu89
LEX = lex
YACC = yacc

default: expl-bin ltranslate

ltranslate: ltranslate.o
		$(CC) $(CFLAGS) -o ltranslate ltranslate.lex.o

ltranslate.o: ltranslate.lex.c
		$(CC) $(CFLAGS) -w -c ltranslate.lex.c

ltranslate.lex.c: ltranslate.l
		@if [ ! -f ltranslate.lex.c ]; then $(LEX) -o ltranslate.lex.c ltranslate.l; fi

expl-bin: lex.yy.o y.tab.o
		$(CC) $(CFLAGS) -o expl-bin lex.yy.o y.tab.o

y.tab.o: y.tab.c y.tab.h abstree.h symboltable.h symboltable.c aa.c codegen.c userdtype.c typecheck.h typecheck.c
		$(CC) $(CFLAGS) -w -c y.tab.c

lex.yy.o: lex.yy.c y.tab.c abstree.h
		$(CC) $(CFLAGS) -w -c lex.yy.c

lex.yy.c: abstree.l
		@if [ ! -f lex.yy.c ]; then $(LEX) abstree.l; fi

y.tab.c: abstree.y
		@if [ ! -f y.tab.c ] || [ ! -f y.tab.h ]; then $(YACC) -d abstree.y; fi

clean:
		$(RM) expl-bin ltranslate *.o y.output assemblycode.xsm
