#include <ranges>
#include <string>
#include <string_view>

#include "last_word_len.hpp"

using std::string_view;
using std::operator""sv;

size_t last_word_len(string_view s) {
  size_t len = 0;

  // Trim whitespace from the back of the string view
  // https://stackoverflow.com/questions/1798112/removing-leading-and-trailing-spaces-from-a-string
  const auto nonwhite = s.find_last_not_of(" \t\n\r\f\v"sv);

  if (nonwhite != std::string::npos) {
    // Strip whitespace from the slice
    s.remove_suffix(nonwhite);
    const auto last_pos = s.rfind(" "sv);

    if (last_pos != std::string::npos) {
      const auto last_word = s.substr(last_pos + 1);
      len = last_word.length();
    }
  }

  return len;
}
