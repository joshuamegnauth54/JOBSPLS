#include <gtest/gtest.h>
#include <span>
#include <string>
#include <string_view>
#include <vector>

#include "../neet.hpp"

using std::span;
using std::string;
using std::vector;
using namespace std::string_view_literals;

namespace {
TEST(LongestPrefixTest, LongestPrefixFound) {
  vector<string> words({"gooby", "golang", "gopher", "Goofy", "government"});
  EXPECT_EQ("go"sv, longest_prefix(span(words)));
}
} // namespace
