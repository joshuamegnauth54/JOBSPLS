use std::{
    collections::{hash_map::DefaultHasher, HashMap},
    hash::{Hash, Hasher},
};

fn fill_map(s: &str) -> HashMap<char, usize> {
    let mut map = HashMap::default();
    for c in s.chars() {
        *map.entry(c).or_default() += 1;
    }

    map
}

/// [anagram_alt] is more robust (I think).
pub fn anagram(s1: &str, s2: &str) -> bool {
    let s1_map = fill_map(s1);
    let s2_map = fill_map(s2);

    s1_map.iter().all(|(c, count)| {
        s2_map
            .get_key_value(c)
            .map(|(c2, count2)| c == c2 && count == count2)
            .unwrap_or_default()
    })
}

fn anagram_alt_hash(s: &str) -> u64 {
    let mut sorted: Vec<_> = s.to_lowercase().chars().collect();
    sorted.sort_unstable();

    // Hash the sorted chars
    let mut state = DefaultHasher::new();
    sorted.hash(&mut state);
    state.finish()
}

pub fn anagram_alt(s1: &str, s2: &str) -> bool {
    anagram_alt_hash(s1) == anagram_alt_hash(s2)
}

#[cfg(test)]
mod tests {}
