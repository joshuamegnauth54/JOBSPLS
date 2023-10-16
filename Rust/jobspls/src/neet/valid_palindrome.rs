pub fn valid_palindrome(word: &str) -> bool {
    let mid = word.chars().count() / 2;
    word.chars()
        .take(mid)
        .map(|c| c.to_ascii_lowercase())
        .eq(word.chars().map(|c| c.to_ascii_lowercase()).rev().take(mid))
}

#[cfg(test)]
mod tests {
    use super::valid_palindrome;

    #[test]
    fn valid_palindromes_work() {
        let palins = [
            "tattarrattat",
            "level",
            "racecar",
            "degged",
            "selles",
            "dewed",
        ];
        assert!(palins.iter().copied().all(valid_palindrome));
    }

    #[test]
    fn invalid_palindromes() {
        let words = ["cat", "dog", "say", "meow"];
        assert!(!words.iter().copied().all(valid_palindrome));
    }
}
