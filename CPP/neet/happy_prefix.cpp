#include <cstddef>
#include <optional>
#include <string_view>
#include <utility>
#include <version>

#include "happy_prefix.hpp"

using std::optional;
using std::string_view;

enum HappySuffixState { SEARCH, ACCUMULATE };

// See the Zig implementation for detailed comments.
optional<HappyPrefix> happy_prefix(string_view domain) {
  if (domain.length() < 2) {
    return {};
  }

  auto state = HappySuffixState::SEARCH;
  size_t prefix = 0;
  size_t suffix = 0;

  for (size_t i = 0; i < domain.length(); ++i) {
    switch (state) {
    case HappySuffixState::SEARCH:
      if (domain[0] == domain[i]) {
        suffix = i;
        state = HappySuffixState::ACCUMULATE;
      }
      break;
    case HappySuffixState::ACCUMULATE:
      prefix += 1;
      if (domain[prefix] != domain[suffix]) {
        prefix = 0;
        suffix = 0;
        state = HappySuffixState::SEARCH;
      }
      break;
    default:
#ifdef __cpp_lib_unreachable
      std::unreachable();
#else
      return {};
#endif
    }
  }

  if (suffix != 0) {
    return HappyPrefix{domain, prefix, suffix};
  }

  return {};
}

string_view HappyPrefix::into_prefix() const {
  return string_view(view.cbegin(), view.cbegin() + prefix_end + 1);
}
