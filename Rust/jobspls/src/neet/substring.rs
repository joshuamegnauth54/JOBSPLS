pub fn substring(s: &str, sub: &str) -> bool {
    s.chars()
        .fold(sub.chars().peekable(), |mut schars, ch| {
            if schars.peek().map(|&sch| sch == ch).unwrap_or_default() {
                _ = schars.next();
            }
            schars
        })
        .next()
        .is_none()
}

#[cfg(test)]
mod tests {
    use super::substring;

    #[test]
    fn substring_found() {
        let s = "Eeveelution";
        let sub = "Eevee";
        assert!(substring(s, sub));
    }
}
