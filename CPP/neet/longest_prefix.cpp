#include <span>
#include <string_view>
#include <utility>
#include <vector>

#include "longest_prefix.hpp"

using std::pair;
using std::span;
using std::string_view;
using std::vector;

pair<size_t, size_t>
longest_prefix(const span<const span<const string_view>> words) {
  if (words.size < 2) {
    return {0, 0};
  }

  // Convert all of the words to lower case

  // Sort lexicographically

  // Check for a common prefix for the first and last words
}
