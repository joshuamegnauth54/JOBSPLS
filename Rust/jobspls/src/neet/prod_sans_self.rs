use std::num::NonZeroI32;

use num::Integer;

/// Product of an array sans the element at `i`.
///
/// # WARNING: I barely understand this stupid question.
///
/// # Panics
/// Panics if `i` is out of range for `nums`.
#[allow(clippy::needless_lifetimes)]
pub fn prod_sans_self_div<'slice>(nums: &'slice [i32]) -> impl Iterator<Item = i32> + 'slice {
    // Product of entire array
    std::iter::repeat(nums.iter().copied().product::<i32>())
        .take(nums.len())
        .zip(nums.iter().copied())
        // Total product / nums[i] | i != 0
        .map(|(prod, orig)| prod / NonZeroI32::new(orig).map(NonZeroI32::get).unwrap_or(1))
}

// pub fn prod_sans_self<I>(nums: &[I], i: usize) -> Vec<I>
// where I: Integer + Copy
// {
//     nums.iter().scan(1, |state, val| {
//
//     })
// }
