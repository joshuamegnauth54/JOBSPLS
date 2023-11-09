#ifndef JOSH_CONSEC_SEQUENCE_HPP
#define JOSH_CONSEC_SEQUENCE_HPP

#include <span>
#include <type_traits>
#include <unordered_set>
#include <vector>

#ifdef HAS_STDCKDINT
#include <stdckdint.h>
#endif

template <typename I>
  requires(std::is_integral_v<I>)
std::vector<I> consec_sequence(std::span<I> haystack) {
  const auto all_nums = std::unordered_set<I>(haystack.begin(), haystack.end());
  std::vector<I> longest;

  for (const auto num : haystack) {
#ifdef HAS_STDCKDINT
    I prev = 0;
    if (!ckd_sub(&prev, num, 1)) {
      continue;
    }
#else
    // WARN: May overflow without stdckdint
    const auto prev = num - 1;
#endif

    // Skip if the set contains the preceding num
    if (all_nums.contains(prev)) {
      continue;
    }

    std::vector<I> current;
    auto next = num;
    while (all_nums.contains(next)) {
      current.push_back(next);

#ifdef HAS_STDCKDINT
      // Break on overflow
      if (!ckd_add(&next, next, 1)) {
        break;
      }
#else
      // WARN: May overflow without stdckdint
      next += 1;
#endif
    }

    // Check which sequence is longer and swap
    if (current.size() > longest.size()) {
      longest.swap(current);
    }
  }

  return longest;
}

#endif
