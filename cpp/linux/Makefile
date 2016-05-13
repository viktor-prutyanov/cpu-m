all:
	@g++ -std=gnu++11 -g main.cpp -Wall -Wcast-qual -Wcast-align \
	-Wwrite-strings -Winline -Wredundant-decls -Wpointer-arith \
	-o asm

build:
	@g++ -std=gnu++11 -g main.cpp -Wall -Wcast-qual -Wcast-align \
	-Wwrite-strings -Winline -Wredundant-decls -Wpointer-arith \
	-o asm && ./asm && echo ''

clean:
	@rm -rf *.o asm