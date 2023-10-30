use num::{CheckedAdd, Integer};
use std::{
    cmp::Ordering,
    fmt::{Debug, Display},
};

pub fn two_sum_ordered<I>(haystack: &[I], target: I) -> Option<(usize, usize)>
where
    I: Integer + CheckedAdd + Clone + Copy + Debug + Display,
{
    let mut left = 0;
    let mut right = haystack.len() - 1;

    while left < right {
        let Some(sum) = haystack[left].checked_add(&haystack[right]) else {
        continue;
    };

        match sum.cmp(&target) {
            Ordering::Less => left += 1,
            Ordering::Equal => return Some((left, right)),
            Ordering::Greater => right -= 1,
        }
    }

    None
}

#[cfg(test)]
mod tests {
    use super::two_sum_ordered;

    #[test]
    fn test_two_sum_ii_ex_1() {
        let haystack = [2, 7, 11, 15];
        let target = 9;

        let (i, j) = two_sum_ordered(&haystack, target).expect("should find both indices");
        assert_eq!(target, haystack[i] + haystack[j]);
    }

    #[test]
    fn test_two_sum_ii_ex_2() {
        let haystack = [2, 3, 4];
        let target = 6;

        let (i, j) = two_sum_ordered(&haystack, target).expect("should find both indices");
        assert_eq!(target, haystack[i] + haystack[j]);
    }

    #[test]
    fn test_two_sum_ii_ex_3() {
        let haystack = [-1, 0];
        let target = -1;

        let (i, j) = two_sum_ordered(&haystack, target).expect("should find both indices");
        assert_eq!(target, haystack[i] + haystack[j]);
    }
}
