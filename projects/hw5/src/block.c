#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "[ERROR] block <src> <dest>\n");
        exit(EXIT_FAILURE);
    }

    FILE *src, *dest;
    const size_t BUFFER_SIZE = 20;
    char *buffer[BUFFER_SIZE];
    size_t read_size;

    if ((src = fopen(argv[1], "r")) == NULL) {
        perror("[ERROR] src");
        exit(EXIT_FAILURE);
    }
    if ((dest = fopen(argv[2], "w")) == NULL) {
        puts("[ERROR] dest");
        exit(EXIT_FAILURE);
    }

    while ((read_size = fread(buffer, sizeof(char), BUFFER_SIZE, src)) ==
           BUFFER_SIZE) {
        fwrite(buffer, sizeof(char), BUFFER_SIZE, dest);
    }
    fwrite(buffer, sizeof(char), read_size, dest);

    fclose(src);
    fclose(dest);
    exit(EXIT_SUCCESS);
}
