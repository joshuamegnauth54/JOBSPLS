use std::{
    collections::{hash_map::DefaultHasher, HashMap},
    hash::{Hash, Hasher},
};

pub fn group_anagrams<'word>(words: &[&'word str]) -> Vec<Vec<&'word str>> {
    let filter = words.iter().filter_map(|word| {
        word.split_whitespace().next().map(|s| {
            let mut chars: Vec<_> = s.chars().collect();
            chars.sort();
            let mut hasher = DefaultHasher::new();
            chars.hash(&mut hasher);
            (hasher.finish(), s)
        })
    });

    let mut groups = HashMap::<u64, Vec<&str>>::new();

    for (hash, word) in filter {
        groups.entry(hash).or_default().push(word);
    }

    groups.into_values().collect()
}
