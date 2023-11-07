#include "../neet.hpp"
#include <gtest/gtest.h>
#include <vector>

using std::vector;

namespace {
TEST(ContainsDuplicatesTest, HasDupes) {
  vector<int> dupes({14, 28, 42, 14, 28, 42, 42, 24, 24});
  EXPECT_EQ(true, containsDuplicate(dupes));
}

TEST(ContainsDuplicatesTest, NoDupes) {
  vector<int> no_dupes({14, 28, 42});
  EXPECT_EQ(false, containsDuplicate(no_dupes));
}
} // namespace
