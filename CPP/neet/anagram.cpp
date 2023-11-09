#include <cstddef>
#include <stdexcept>
#include <string_view>
#include <unordered_map>
#include <utility>

#include "anagram.hpp"

using std::pair;
using std::size_t;
using std::string_view;
using std::unordered_map;

void fill_map(const string_view s, unordered_map<char, size_t> &counts) {
  for (auto ch : s) {
    const auto &[node, success] = counts.insert(pair(ch, 1));
    // Failed insertion = ch already in the map
    if (!success) {
      counts[ch] += 1;
    }
  }
}

bool anagram(const string_view s1, const string_view s2) {
  if (s1.size() != s1.size()) {
    return false;
  }

  unordered_map<char, size_t> s1_map;
  unordered_map<char, size_t> s2_map;

  fill_map(s1, s1_map);
  fill_map(s2, s2_map);

  for (const auto &[key, value] : s1_map) {
    try {
      const auto &s2_value = s2_map.at(key);
      if (value != s2_value) {
        return false;
      }
    } catch (std::out_of_range &e) {
      return false;
    }
  }

  return true;
}
