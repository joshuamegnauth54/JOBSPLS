use std::{
    collections::{BinaryHeap, HashSet},
    hash::Hash,
    ops::{Add, Sub},
};

pub fn consec_sequence_heap<T>(haystack: &[T])
where
    T: Copy,
{
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
