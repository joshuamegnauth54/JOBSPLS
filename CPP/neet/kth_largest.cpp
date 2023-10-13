#include <algorithm>
#include <optional>
#include <span>
#include <vector>

#include "kth_largest.hpp"

using std::span;

template <typename T> std::optional<T> kth_largest(span<T> haystack, size_t k) {
  // C++ iterators are silly so if k > span.size() it's UB
  if (haystack.size() < k) {
    return {};
  }

  // Sorted heap (ascending)
  std::ranges::make_heap(haystack.begin(), haystack.end());
  std::ranges::sort_heap(haystack.begin(), haystack.end());

  auto end = haystack.cend();
  end -= k;

  return *end;
}
