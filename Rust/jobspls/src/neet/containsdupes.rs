use std::{collections::HashSet, hash::Hash};

pub fn contains_dupes<T>(values: &[T]) -> bool
where
    T: Eq + Hash,
{
    let set: HashSet<_> = values.iter().collect();
    set.len() != values.len()
}

#[cfg(test)]
mod tests {
    use super::contains_dupes;

    #[test]
    fn has_dupes() {
        let dupes = [14, 28, 42, 28, 14, 56];
        assert!(contains_dupes(&dupes));
    }

    #[test]
    fn no_dupes() {
        let unique = [14, 28, 42];
        assert!(!contains_dupes(&unique));
    }
}
