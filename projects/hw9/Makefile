CC:=clang
CFLAGS:=-Wall -Wextra

all: main

bin/%: build/%.o
	@mkdir -p bin
	$(CC) -o $@ $^

build/%.o: src/%.c
	@mkdir -p build
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: all clean
clean:
	rm -rf bin/ build/ datafile
