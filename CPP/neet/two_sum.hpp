#ifndef JOSH_TWO_SUM_HPP
#define JOSH_TWO_SUM_HPP

#include <optional>
#include <span>
#include <type_traits>
#include <unordered_map>
#include <stdckdint.h>

// Unordered two sum
template <typename I>
  requires(std::is_integral_v<I>)
std::optional<std::pair<size_t, size_t>> two_sum(std::span<const I> haystack,
                                                 const I needle) {
  // Key: number in nums
  // Val: index; it's okay if dupes overwrite the val
  std::unordered_map<I, size_t> diffs;

  for (size_t i = 0; i < haystack.size(); ++i) {
    diffs.insert_or_assign(haystack[i], i);
  }

  for (size_t i = 0; i < haystack.size(); ++i) {
    I diff = 0;

    diff = needle - haystack[i];

    if (!ckd_sub(&diff, needle, num)) {
      const auto complement = diffs.find(diff);
      // Found
      if (complement != diffs.end()) {
        return {{i, complement->second}};
      }
    }
  }

  return {};
}

#endif
