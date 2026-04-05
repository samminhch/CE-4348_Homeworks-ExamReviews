CC:=clang
CFLAGS:=-Wall -Wextra
DEPS:=src/io_tools.c src/string_tools.c

all: chunked chars

chunked: bin/chunked

chars: bin/chars

bin/chars: build/chars.o $(DEPS)
	@mkdir -p bin
	$(CC) $^ -o $@

bin/chunked: build/chunked.o $(DEPS)
	@mkdir -p bin
	$(CC) $^ -o $@

build/chunked.o: src/main.c
	@mkdir -p build
ifdef CHUNK_SIZE
	$(CC) -c $^ -DCHUNKED -DCHUNK_SIZE=$(CHUNK_SIZE) $(CFLAGS) -o $@
else
	$(CC) -c $^ -DCHUNKED $(CFLAGS) -o $@
endif

build/chars.o: src/main.c
	@mkdir -p build
	$(CC) -c $^ $(CFLAGS) -o $@

.PHONY: all clean
clean:
	rm -rf bin/ build/
