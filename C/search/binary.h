#ifndef JOSH_SEARCH_BINARY_H
#define JOSH_SEARCH_BINARY_H

#include <stdlib.h>

struct BinaryResult {
  bool found;
  union {
    size_t index;
    size_t expected;

  } result;
};

// Search for `needle` in `haystack` with binary search.
//
// WARNING: Recursive
//
// # Arguments
// * len:       Length of `haystack`
// * haystack:  Array to search
// * lower:     Lower bound to search in `haystack`
// * upper:     Upper bound to search in `haystack`
// * needle:    Item to find
//
// NOTE: `lower` and `upper` must be smaller than `len`
struct BinaryResult binary(size_t const len, int const haystack[len],
                           size_t const lower, size_t const upper,
                           int const needle);

#endif
