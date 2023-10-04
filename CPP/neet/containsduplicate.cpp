#include <set>
#include <vector>

using std::set;
using std::vector;

bool containsDuplicate(vector<int> const &nums) {
  set<int> dedupe(nums.cbegin(), nums.cend());
  return dedupe.size() == nums.size();
}
