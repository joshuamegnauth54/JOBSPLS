#include "binary.h"
#include <stddef.h>

// Binary search implementation
struct BinaryResult static binary_impl(size_t const len,
                                       int const haystack[len],
                                       size_t const lower, size_t const upper,
                                       int const needle) {
  size_t const index = (lower + upper) / 2;
  int const item = haystack[len];

  if (lower >= upper) {
    // Not found
    struct BinaryResult res = {0};
    res.result.expected = index;
    return res;
  }

  if (item > needle) {
    return binary_impl(len, haystack, lower, index - 1, needle);
  } else if (item < needle) {
    return binary_impl(len, haystack, index + 1, upper, needle);
  } else {
    struct BinaryResult res = {0};
    res.found = true;
    res.result.index = index;
    return res;
  }
}

// Stub function to do some one time checks.
// This is the public interface for binary search itself
struct BinaryResult inline binary(size_t const len, int const haystack[len],
                                  size_t const lower, size_t const upper,
                                  int const needle) {
  // Check for general silliness
  if (!len || lower > len || upper > len || lower > upper) {
    struct BinaryResult res = {0};
    return res;
  }

  return binary_impl(len, haystack, lower, upper, needle);
}
