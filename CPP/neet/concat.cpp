#include <algorithm>
#include <iterator>
#include <span>
#include <vector>

#include "concat.hpp"

using std::span;
using std::vector;

template <typename T>
vector<T> repeat_array(const span<const T> values,
                       size_t const amount) {
  vector<T> vec(values.size() * amount);

  for (size_t i = 0; i < amount; ++i) {
    std::ranges::copy(values.cbegin(), values.cend(), std::back_inserter(vec));
  }

  return vec;
}
