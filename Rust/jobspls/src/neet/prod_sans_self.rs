use std::num::NonZeroI32;

use num::{Integer, NumCast};

/// Product of an array sans the element at `i`.
///
/// # WARNING: I barely understand this stupid question.
#[allow(clippy::needless_lifetimes)]
pub fn prod_sans_self_div<'slice>(nums: &'slice [i32]) -> impl Iterator<Item = i32> + 'slice {
    // Product of entire array
    std::iter::repeat(nums.iter().copied().product::<i32>())
        .take(nums.len())
        .zip(nums.iter().copied())
        // Total product / nums[i] | i != 0
        .map(|(prod, orig)| prod / NonZeroI32::new(orig).map(NonZeroI32::get).unwrap_or(1))
}

/// Cumulative product shifted over by one
pub fn cumulative_shift<'slice, I>(nums: &'slice [I]) -> impl Iterator<Item = I> + 'slice
where
    I: Integer + Copy + NumCast + std::ops::Mul<I, Output = I>,
{
    nums.iter()
        .scan((num::cast::<i32, I>(1).unwrap(), 1), |(state, _), &val| {
            // State is the current sum up to this point
            // The value to yield is always one behind which effectively skips the i-th value
            Some((*state * val, *state))
        })
        .map(|(_, to_yield)| to_yield)
}
//
// pub fn prod_sans_self<I>(nums: &[I]) -> Vec<I>
// where
//     I: Integer + Copy + NumCast + std::ops::Mul<I, Output = I>,
// {
//     cumulative_shift(nums).zip(cumulative_shift(nums)).product()
// }
