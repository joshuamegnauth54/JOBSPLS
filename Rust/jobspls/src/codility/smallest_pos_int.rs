use std::{collections::BTreeSet, iter};

use num::{CheckedAdd, FromPrimitive, Integer};

pub fn smallest_pos_int<I>(haystack: &[I]) -> Option<I>
where
    I: Integer + CheckedAdd + FromPrimitive + Copy,
{
    let hayset = BTreeSet::from_iter(haystack.iter().copied());
    iter::successors(I::from_u8(1), |next| {
        next.checked_add(&I::from_u8(1).unwrap())
    })
    .find(|val| !hayset.contains(val))
}
