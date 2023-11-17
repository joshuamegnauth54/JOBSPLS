pub fn replace_vals_right(nums: &[i32]) -> Vec<i32> {
    nums.iter()
        .copied()
        .skip(1)
        .rev()
        // .skip(1)
        .scan(nums.last().copied().unwrap_or(-1), |state, x| {
            *state = x.max(*state);
            Some(*state)
        })
        .chain([-1])
        .collect()
}

#[cfg(test)]
mod tests {
    use super::replace_vals_right;

    #[test]
    fn replace_vals_right_ex1() {
        let values = [17, 18, 5, 4, 6, 1];
        let expected = [18, 6, 6, 6, 1, -1];
        let actual = replace_vals_right(&values);
        
        for n in actual.iter() {
            println!("{n}");
        }

        assert!(expected.iter().copied().eq(actual.into_iter()));
    }
}
