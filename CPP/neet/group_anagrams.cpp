#include "group_anagrams.hpp"

#include <algorithm>
#include <cassert>
#include <span>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

using std::span;
using std::string;
using std::string_view;
using std::unordered_map;
using std::vector;
using std::operator""sv;

string_view strip_whitespace(string_view s) {
  const auto nonwhite = s.find_last_not_of(" \t\r\n\f\v"sv);

  if (nonwhite != string::npos) {
    s.remove_suffix(nonwhite);
  }

  return s;
}

vector<vector<string_view>> group_anagrams(span<const string> words) {
  unordered_map<string, vector<string_view>> groups;

  for (const auto &word : words) {
    auto stripped = string(strip_whitespace(word));

    // Transform string to lowercased ASCII (mutates)
    std::transform(stripped.begin(), stripped.end(), stripped.begin(),
                   [](unsigned char ch) { return std::tolower(ch); });

    // Sort and insert string
    std::sort(stripped.begin(), stripped.end());
    if (groups.contains(stripped)) {
      groups[stripped].emplace_back(word);
    } else {
      vector<string_view> anagrams = {word};
      const auto [_it, success] = groups.emplace(stripped, anagrams);
      assert(success);
    }
  }

  // Move map's values (the grouped anagrams) into a vector
  vector<vector<string_view>> anagrams;
  anagrams.reserve(groups.size());
  std::transform(groups.begin(), groups.end(), std::back_inserter(anagrams),
                 [](const auto pair) { return pair.second; });

  return anagrams;
}
