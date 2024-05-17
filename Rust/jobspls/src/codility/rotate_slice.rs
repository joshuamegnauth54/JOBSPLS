pub fn rotate_slice<'slice, T: Clone>(
    slice: &'slice [T],
    by: usize,
) -> impl Iterator<Item = T> + 'slice {
    slice
        .iter()
        .cloned()
        .cycle()
        .skip(slice.len().abs_diff(by) % slice.len())
        .take(slice.len())
}

#[cfg(test)]
mod tests {
    use super::rotate_slice;

    #[test]
    fn simple_shift_works() {
        let slice = [4, 9, 11, 6];

        let actual = rotate_slice(&slice, 1);
        let expected = [6, 4, 9, 11];

        assert!(actual.eq(expected));
    }

    #[test]
    fn zero_shift_works() {
        let slice = [6, 7, 8, 9];

        let actual = rotate_slice(&slice, 0);
        let expected = slice;

        assert!(actual.eq(expected));
    }

    #[test]
    fn over_shift_works() {
        let slice = [3, 4, 5, 6];

        let actual = rotate_slice(&slice, 6);
        let expected = [5, 6, 3, 4];

        assert!(actual.eq(expected));
    }
}
