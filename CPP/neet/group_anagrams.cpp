#include "group_anagrams.hpp"

#include <algorithm>
#include <hash>
#include <map>
#include <span>
#include <string>
#include <string_view>
#include <vector>

using std::map;
using std::span;
using std::string;
using std::string_view;
using std::vector;
using std::operator""sv;

string_view strip_whitespace(string_view s) {
  const auto nonwhite = s.find_last_not_of(" \t\r\n\f\v"sv);

  if (nonwhite != string::npos) {
    s.remove_suffix(nonwhite);
  }

  return s;
}

vector<vector<string_view>> group_anagrams(span<string> words) {
  map<string, vector<string_view>> groups;

  for (const auto &word : words) {
    auto stripped = string(strip_whitespace(word));

    // Transform string to lowercased ASCII (mutates)
    std::transform(stripped.begin(), stripped.end(), stripped.begin(),
                   [](unsigned char ch) { return std::tolower(ch); });

    // Sort and hash string
    std::sort(stripped.begin(), stripped.end());
    const auto hash = std::hash<string>{}(stripped);
  }
}
