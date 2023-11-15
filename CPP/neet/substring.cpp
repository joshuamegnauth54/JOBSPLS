#include <string_view>

using std::string_view;

bool contains_substring(const string_view s, const string_view sub) {
  auto sub_iter = sub.begin();
  auto s_iter = s.begin();

  // Iterate through either sub or s (i.e. stop when either is exhausted)
  // s_iter is always incremented because sub_iter should only be incremented if
  // the chars at both indices are equal
  for (; sub_iter != sub.end() && s_iter != s.end(); s_iter++) {
    if (*sub_iter == *s_iter) {
      sub_iter++;
    }
  }

  // Traversing sub means sub is a substring of s
  return sub_iter == sub.end();
}
