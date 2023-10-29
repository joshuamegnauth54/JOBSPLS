use std::cmp::Ordering;

pub fn two_sum_ordered(haystack: &[i32], target: i32) -> Option<(usize, usize)> {
    let mut left = 0;
    let mut right = haystack.len() - 1;

    while left < right {
        let sum = haystack[left] + haystack[right];

        match sum.cmp(&target) {
            Ordering::Less => left += 1,
            Ordering::Equal => return Some((left, right)),
            Ordering::Greater => right -= 1,
        }
    }

    None
}
