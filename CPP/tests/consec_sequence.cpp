#include <gtest/gtest.h>
#include <span>
#include <vector>

#include "neet.hpp"

using std::span;
using std::vector;

namespace {
TEST(ConsecSequenceTest, FoundConsecSeq) {
  vector<int> haystack({4, 1, 3, 2, 7, 8, 9, 14, 11, 12, 13, 10});
  vector<int> expected({7, 8, 9, 10, 11, 12, 13, 14});

  const auto got = consec_sequence(span(haystack));

  EXPECT_EQ(expected.size(), got.size());
  for (auto i = 0; i < expected.size(); ++i) {
    EXPECT_EQ(expected[i], got[i]);
  }
}
} // namespace
