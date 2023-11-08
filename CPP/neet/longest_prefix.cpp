#include <algorithm>
#include <cctype>
#include <span>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "longest_prefix.hpp"

using std::pair;
using std::span;
using std::string;
using std::string_view;
using std::vector;

string_view longest_prefix(const span<const string> words) {
  if (words.size() < 2) {
    return "";
  }

  vector<string> sorted(words.size());

  // Convert all of the words to lower case
  // TODO: Support UTF-8? Does it matter for LeetCode?
  auto element = sorted.begin();
  for (auto word = words.begin(); word < words.end() && element < sorted.end();
       ++word, ++element) {
    string lcword(*word);
    std::transform(lcword.cbegin(), lcword.cend(), lcword.begin(),
                   [](unsigned char c) { return std::tolower(c); });
    *element = lcword;
  }

  // Sort lexicographically
  std::sort(sorted.begin(), sorted.end());

  // Check for a common prefix for the first and last words
  string_view first{sorted.front()};
  string_view last{sorted.back()};

  // Prefix is 0 to prefix
  size_t prefix = 0;
  while (prefix < first.size()) {
    if (first[prefix] != last[prefix]) {
      break;
    }

    ++prefix;
  }

  return string_view(first.cbegin(), first.cbegin() + prefix);
}
