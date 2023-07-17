use std::cmp::Ordering;

pub trait BinarySearch<T> {
    fn binary_search(&self, lower: usize, upper: usize, find: &T) -> Result<usize, usize>;
}

impl<T> BinarySearch<T> for &[T]
where
    T: PartialOrd,
{
    fn binary_search(&self, lower: usize, upper: usize, find: &T) -> Result<usize, usize> {
        let index = (lower + upper) / 2;

        if lower > upper {
            Err(index)?
        }

        match self[index].partial_cmp(find) {
            Some(Ordering::Less) => self.binary_search(index + 1, upper, find),
            Some(Ordering::Equal) => Ok(index),
            Some(Ordering::Greater) => self.binary_search(lower, index - 1, find),
            None => Err(index),
        }
    }
}
