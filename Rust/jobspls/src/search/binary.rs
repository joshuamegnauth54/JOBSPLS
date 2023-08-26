use std::cmp::Ordering;

pub trait BinarySearch<T> {
    fn binarysearch(&self, lower: usize, upper: usize, find: &T) -> Result<usize, usize>;
}

impl<T> BinarySearch<T> for &[T]
where
    T: PartialOrd,
{
    fn binarysearch(&self, lower: usize, upper: usize, find: &T) -> Result<usize, usize> {
        let index = (lower + upper) / 2;

        if lower > upper {
            Err(index)?
        }

        match self[index].partial_cmp(find) {
            Some(Ordering::Less) => self.binarysearch(index + 1, upper, find),
            Some(Ordering::Equal) => Ok(index),
            Some(Ordering::Greater) => self.binarysearch(lower, index - 1, find),
            None => Err(index),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::BinarySearch;

    #[test]
    fn binary_simple_found() {
        let haystack: Vec<_> = (0..100).collect();
        let res = haystack
            .as_slice()
            .binarysearch(0, haystack.len(), &14)
            .expect("14 should be found in 0..100");
        assert_eq!(res, 14);
    }

    #[test]
    fn binary_simple_not_found() {
        let haystack: Vec<_> = (0..10).map(|x| x * 14).collect();
        let res = haystack
            .as_slice()
            .binarysearch(0, haystack.len(), &24)
            .expect_err("24 shouldn't be found in this test");
        assert_eq!(res, 1);
    }
}
