/// Return the length of the last word in a string
pub fn last_word_len(s: &str) -> Option<usize> {
    s.split_whitespace().last().map(str::len)
}

#[cfg(test)]
mod tests {
    use super::last_word_len;

    #[test]
    fn test_found_length() {
        let len = last_word_len("   \tMeow      is a    four     letter word                    ")
            .unwrap();
        assert_eq!(len, 4);
    }

    #[test]
    fn test_empty_str_no_last_word() {
        assert!(last_word_len("").is_none())
    }
}
