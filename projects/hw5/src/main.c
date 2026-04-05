#include "string_tools.h"

#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

void sigint_handler() {
    exit(EXIT_SUCCESS);
}

void free_strings(char **strings, size_t num_strings) {
    for (size_t idx = 0; idx < num_strings; idx++) {
        free(strings[idx]);
    }
    free(strings);
}

int main() {
    signal(SIGINT, sigint_handler);
    const char prompt[] = "OS> ";
    char *input         = NULL;
    size_t input_size   = 0;

    while (true) {
        printf("%s", prompt);
        if (getline(&input, &input_size, stdin) == -1) {
            free(input);
            exit(EXIT_SUCCESS);
        }
        input[strcspn(input, "\n")] = '\0';

        size_t num_args;
        char **args = str_split(input, " ", &num_args);
        if (!args || num_args == 0) {
            continue;
        }
        char **argv = realloc(args, (num_args + 1) * sizeof(char *));
        if (!argv) {
            perror("[ERROR] Memory allocation");
            free_strings(args, num_args);
            continue;
        }
        argv[num_args] = NULL;

        pid_t process = fork();
        if (process == 0) {
            execvp(argv[0], argv);
            perror("[ERROR] execvp");
            exit(EXIT_FAILURE);
        } else if (process > 0) {
            waitpid(process, NULL, 0);
        }
        free_strings(argv, num_args);
    }
    return 0;
}
