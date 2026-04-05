CC:=clang
CFLAGS:=-Wall -Wextra
SRCs:=$(wildcard src/*c)
OBJs:=$(SRCs:src/%.c=build/%.o)
TARGET:=bin/pstree

all: $(TARGET)

$(TARGET): $(OBJs)
	@mkdir -p bin
	$(CC) -o $@ $^

build/%.o: src/%.c
	@mkdir -p build
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: all clean test
clean:
	rm -rf bin/ build/
