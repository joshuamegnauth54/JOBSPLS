#ifndef JOSH_CONTAINS_DUPLICATE_HPP
#define JOSH_CONTAINS_DUPLICATE_HPP

#include <span>
#include <type_traits>
#include <unordered_set>

template <typename I>
  requires(std::is_integral_v<I>) bool
containsDuplicate(const std::span<const I> nums) {
  std::unordered_set<I> dedupe(nums.cbegin(), nums.cend());
  return dedupe.size() != nums.size();
}

#endif
