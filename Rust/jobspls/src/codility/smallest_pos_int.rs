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

#[cfg(test)]
mod tests {
    use super::smallest_pos_int;

    #[test]
    fn missing_one_pos_is_found() {
        let actual = smallest_pos_int(&[2, 3, 4]).expect("Should find a value");
        let expected = 1;
        assert_eq!(expected, actual);
    }

    #[test]
    fn missing_one_neg_is_found() {
        let actual = smallest_pos_int(&[-1, -2]).expect("Should find a value");
        let expected = 1;
        assert_eq!(expected, actual);
    }

    #[test]
    fn missing_one_zero_is_found() {
        let actual = smallest_pos_int(&[0]).expect("Should find a value");
        let expected = 1;
        assert_eq!(expected, actual);
    }
}
