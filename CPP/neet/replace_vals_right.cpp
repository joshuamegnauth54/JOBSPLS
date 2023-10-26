#include "replace_vals_right.hpp"

#include <cstdint>
#include <span>
#include <vector>

using std::int32_t;
using std::span;
using std::vector;

#include <iostream>

vector<int32_t> replace_vals_right(span<const int32_t> nums) {
  if (nums.size() < 1) {
    return vector<int32_t>(nums.begin(), nums.end());
  }

  // Initial value is -1 because that's the sentinel for represents missing vals
  vector<int32_t> out(nums.size(), -1);
  int32_t max = -1;

  // Iterate backwards through both sequences BUT skip the last number in the
  // output vector This ensures the final value is -1
  auto out_it = out.rbegin() + 1;
  for (auto num = nums.rbegin(); out_it < out.rend() && num < nums.rend();
       ++out_it, ++num) {
    max = std::max(max, *num);
    *out_it = max;
  }

  return out;
}
