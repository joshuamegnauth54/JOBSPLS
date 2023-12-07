pub fn replace_vals_right_iter(nums: &[i32]) -> Vec<i32> {
    let mut out: Vec<_> = nums
        .iter()
        .copied()
        .rev()
        .scan(-1, |state, x| {
            let current = *state;
            *state = x.max(*state);
            Some(current)
        })
        .collect();
    // Can't reverse a `Scan`. RIP.
    out.reverse();
    out
}

#[cfg(test)]
mod tests {
    use super::replace_vals_right_iter;

    #[test]
    fn replace_vals_right_ex1() {
        let values = [17, 18, 5, 4, 6, 1];
        let expected = [18, 6, 6, 6, 1, -1];
        let actual = replace_vals_right_iter(&values);

        assert!(expected.iter().copied().eq(actual.into_iter()));
    }

    #[test]
    fn replace_vals_right_ex2() {
        let values = [400];
        let expected = [-1];
        let actual = replace_vals_right_iter(&values);

        assert!(expected.iter().copied().eq(actual.into_iter()));
    }
}
