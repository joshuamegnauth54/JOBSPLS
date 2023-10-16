use num::{CheckedSub, Integer};
use std::{collections::HashMap, hash::Hash};

pub fn two_sum<I>(nums: &[I], target: I) -> Option<(I, I)>
where
    I: Integer + CheckedSub + Hash + Copy,
{
    let mut complements: HashMap<_, _> = HashMap::new();

    // Iterative because it's straightforward to short circuit
    for (i, &num) in nums.iter().enumerate() {
        if let Some(&i) = complements.get(&num) {
            return Some((num, nums[i]));
        }

        if let Some(complement) = target.checked_sub(&num) {
            complements.entry(complement).or_insert(i);
        }
    }

    None
}

#[cfg(test)]
mod tests {
    use super::two_sum;

    #[test]
    fn found_complement() {
        let nums = [7, 9, 4, 100, 14, 64, 6, 28, 19, 24];
        let target = 42;
        let (a, b) = two_sum(&nums, target).unwrap();
        assert_eq!(a + b, target);
    }
}
