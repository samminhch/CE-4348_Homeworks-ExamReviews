CC:=clang
CFLAGS:=-Wall -Wextra

SRCS:=src/main.c
OJBS:=$(SRCS:src/%.c=build/%.o)
TARGET:=bin/stats

all: $(TARGET)

$(TARGET): $(OJBS)
	@mkdir -p bin
	$(CC) -o $@ $^

build/%.o: src/%.c
	@mkdir -p build
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: all clean
clean:
	rm -rf bin/ build/
