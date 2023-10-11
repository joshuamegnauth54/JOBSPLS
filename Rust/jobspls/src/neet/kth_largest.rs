use std::collections::BinaryHeap;

/// Kth largest element in `haystack` where 0 is the largest
pub fn kth_largest<T: Ord>(haystack: &[T], k: usize) -> Option<&T> {
    BinaryHeap::from_iter(haystack)
        .into_sorted_vec()
        .into_iter()
        .nth(k)
}

#[cfg(test)]
mod tests {
    use super::kth_largest;

    #[test]
    fn kth_largest_success() {
        let nums = [42, 100, 28, 14, 24, 1, 5, 9, 64, 32, 11];
        let k = kth_largest(&nums, 4)
            .copied()
            .expect("should find kth largest");
        assert_eq!(14, k);
    }
}
