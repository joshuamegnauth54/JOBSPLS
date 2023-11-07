#include <span>
#include <unordered_set>

using std::span;
using std::unordered_set;

bool containsDuplicate(const span<const int> nums) {
  unordered_set<int> dedupe(nums.cbegin(), nums.cend());
  return dedupe.size() != nums.size();
}
