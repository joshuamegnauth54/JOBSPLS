pub fn longest_prefix(words: &[&str]) -> Option<String> {
    if words.len() < 2 {
        None
    } else {
        let mut sorted: Vec<_> = words.iter().collect();
        sorted.sort();

        Some(
            sorted
                .first()
                .expect("first string exists")
                .chars()
                .zip(sorted.last().expect("last string exists").chars())
                .map_while(|(a, b)| if a == b { Some(a) } else { None })
                .collect(),
        )
    }
}

#[cfg(test)]
mod tests {
    use super::longest_prefix;

    #[test]
    fn found_longest_prefix() {
        let words = ["good", "goofy", "goober", "gopher", "going", "gone"];
        let prefix = longest_prefix(&words).expect("should find a prefix");
        assert_eq!(prefix, "go");
    }
}
