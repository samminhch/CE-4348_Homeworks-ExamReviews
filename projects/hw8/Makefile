CC:=clang
CFLAGS:=-Wall -Wextra

all: no_lock lock
no_lock: bin/no_lock
lock: bin/lock

bin/%: build/%.o
	@mkdir -p bin
	$(CC) -o $@ $^

build/%.o: src/%.c
	@mkdir -p build
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: all clean
clean:
	rm -rf bin/ build/ datafile
