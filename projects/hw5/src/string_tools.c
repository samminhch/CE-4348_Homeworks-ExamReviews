#include "string_tools.h"
char **str_split(const char *str, const char *delimeter, size_t *splits_len) {
    // safety checks
    if (!str || !delimeter || !splits_len) {
        return NULL;
    }

    // Make a working copy of `str`
    char *copy = malloc((strlen(str) + 1) * sizeof(char));
    if (!copy) {
        return NULL;
    }
    strcpy(copy, str);

    size_t capacity = 1, size = 0;
    char **result = malloc(capacity * sizeof(char *));
    if (!result) {
        free(copy);
        return NULL;
    }

    char *token = strtok(copy, delimeter);
    while (token != NULL) {
        size++;

        // Reallocate memory if size > capacity
        if (size > capacity) {
            capacity   <<= 1;
            char **tmp   = realloc(result, capacity * sizeof(char *));

            // If reallocation failed, then return NULL
            if (tmp == NULL) {
                for (size_t idx = 0; idx < size - 1; idx++) {
                    free(result[idx]);
                }
                free(result);
                free(copy);
                return NULL;
            }

            result = tmp;
        }

        result[size - 1] = malloc((strlen(token) + 1) * sizeof(char));
        if (!result[size - 1]) {
          for (size_t idx = 0; idx < size - 1; idx++) {
            free(result[idx]);
          }
          free(result);
          free(copy);
          return NULL;
        }

        strcpy(result[size - 1], token);
        token            = strtok(NULL, delimeter);
    }

    *splits_len = size;
    free(copy);
    return result;
}
