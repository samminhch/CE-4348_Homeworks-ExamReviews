CC:=clang
CFLAGS:=-Wall -Wextra

BLOCK_SRC:=src/block.c
BLOCK_OBJ:=build/block.o
BLOCK_TARGET:=bin/block

CMD_SRC:=src/main.c src/string_tools.c
CMD_OBJs:=$(CMD_SRC:src/%.c=build/%.o)
CMD_TARGET:=bin/runcmd

all: $(BLOCK_TARGET) $(CMD_TARGET)

$(BLOCK_TARGET): $(BLOCK_OBJ)
	@mkdir -p bin
	$(CC) -o $@ $<

$(CMD_TARGET): $(CMD_OBJs)
	@mkdir -p bin
	$(CC) -o $@ $^

build/%.o: src/%.c
	@mkdir -p build
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: all clean
clean:
	rm -rf bin/ build/
