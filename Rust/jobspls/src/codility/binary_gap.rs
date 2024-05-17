use std::{cmp, fmt};

use num::Integer;

pub fn binary_gap<I>(num: I) -> usize
where
    I: Integer + fmt::Binary,
{
    let binary = format!("{num:b}");
    binary
        .chars()
        .fold((0, 0), |(current, min), ch| {
            if ch == '1' {
                (0, cmp::max(current, min))
            } else {
                assert_eq!(ch, '0');
                (current + 1, min)
            }
        })
        .1
}

#[cfg(test)]
mod tests {
    use super::binary_gap;

    #[test]
    fn zero_case_binary_gap() {
        let gap = binary_gap(0);
        assert_eq!(0, gap);
    }

    #[test]
    fn gaps_to_end() {
        let gap = binary_gap(9);
        assert_eq!(2, gap);
    }

    #[test]
    fn i32_max_gap() {
        let gap = binary_gap(i32::MAX);
        assert_eq!(0, gap);
    }
}
