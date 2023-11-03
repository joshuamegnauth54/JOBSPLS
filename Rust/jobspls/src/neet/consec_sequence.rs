use std::{
    cmp::Reverse,
    collections::{BinaryHeap, HashSet},
    hash::Hash,
    ops::{Add, Sub},
};

// This impl is, in fact, totally different from my Zig implementation.
pub fn consec_sequence_heap<T>(haystack: &[T]) -> Vec<T>
where
    T: Copy + Ord + Add<i32, Output = T>,
{
    let mut seqs = BinaryHeap::from_iter(haystack.iter().copied().map(Reverse))
        .into_sorted_vec()
        .into_iter()
        .map(|val| val.0)
        .peekable();
    let mut max: Option<Vec<T>> = None;
    let mut cur = Vec::default();

    while let (Some(num), expected) = (seqs.next(), seqs.peek()) {
        cur.push(num);
        let next = num + 1;

        // Check if the sequence ended
        if expected.map(|&val| val != next).unwrap_or(true) {
            if cur.len() > max.as_ref().map(|vec| vec.len()).unwrap_or_default() {
                max.replace(cur);
            }
            cur = Vec::default();
        }
    }

    max.unwrap_or_default()
}

pub fn consec_sequence_set<T>(haystack: &[T]) -> Vec<T>
where
    T: Hash + Eq + Copy + Sub<i32, Output = T> + Add<i32, Output = T>,
{
    let hayset: HashSet<T> = HashSet::from_iter(haystack.iter().copied());
    let mut max = None;

    for val in haystack.iter() {
        // Short circuit if the previous number exists because that means `val` isn't the start of
        // the seq
        if hayset.contains(&(*val - 1)) {
            continue;
        }

        // Store the current sequence
        let mut current = vec![*val];
        let mut cur_val = *val + 1;

        while let Some(&cur_val_next) = hayset.get(&cur_val) {
            current.push(cur_val_next);
            cur_val = cur_val + 1;
        }

        if current.len() > max.as_ref().map(Vec::len).unwrap_or_default() {
            max.replace(current);
        }
    }

    max.unwrap_or_default()
}

#[cfg(test)]
mod tests {
    use super::consec_sequence_set;

    #[test]
    fn consec_sequence_set_ex_1() {
        let haystack = [100, 4, 200, 1, 3, 2];
        let seq = consec_sequence_set(&haystack);
    }
}
