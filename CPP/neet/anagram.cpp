#include "anagram.hpp"
#include <cstddef>
#include <map>
#include <string_view>
#include <stdexcept>
#include <utility>

using std::map;
using std::pair;
using std::size_t;
using std::string_view;

void fill_map(string_view s, map<char, size_t> &counts) {
  for (auto ch : s) {
    const auto &[node, success] = counts.insert(pair(ch, 1));
    // Failed insertion = ch already in the map
    if (!success) {
      counts[ch] += 1;
    }
  }
}

bool anagram(string_view s1, string_view s2) {
  if (s1.size() != s1.size()) {
    return false;
  }

  map<char, size_t> s1_map;
  map<char, size_t> s2_map;

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
