#ifndef STRING_TOOLS_H_
#define STRING_TOOLS_H_
#include <stdlib.h>
#include <string.h>

/**
 * @brief Splits a string into an array of substrings based on a delimiter.
 *
 * Splits @p str into tokens separated by @p delimiter, returning a
 * heap-allocated array of heap-allocated strings. Both the array and each
 * individual string within it must be freed by the caller when no longer
 * needed.
 *
 * @param str         The input string to split. Must not be NULL.
 * @param delimeter   A string containing the delimiter characters to split on.
 *                    Follows the same semantics as strtok(3). Must not be NULL.
 * @param splits_len  Output parameter set to the number of tokens found.
 *                    Set to 0 on failure. Must not be NULL.
 *
 * @return A heap-allocated array of heap-allocated strings, one per token,
 *         or NULL if any argument is NULL or a memory allocation fails.
 *
 */
char **str_split(const char *str, const char *delimeter, size_t *splits_len);
#endif
