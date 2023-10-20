use std::ops::MulAssign;

use num::{Integer, NumCast};

const CAST_ERR: &str = "`1` should be castable into `I`";

/// Product of `nums` precluding the current element.
///
/// # Example
/// ```rust
/// use jobspls::neet::prod_sans_self;
///
/// let product = prod_sans_self(&[1, 2, 3, 4]);
/// assert!(product.iter().eq([24, 12, 8, 6].iter()))
/// ```
pub fn prod_sans_self<I>(nums: &[I]) -> Vec<I>
where
    I: Integer + NumCast + Copy + MulAssign,
{
    let mut fwd_prod: I = num::cast(1).expect(CAST_ERR);
    let mut product = vec![num::cast(1).expect(CAST_ERR); nums.len()];
    // I tried to solve this functionally, but I gave up for now
    // Algo:
    // * Iterate forward taking the cumulative product up to that point
    // * The first number is skipped
    // * Repeat backwards
    for (&num, prod) in nums.iter().zip(product.iter_mut()) {
        // Skips self because this is the PREVIOUS product (or 1 for the first element)
        *prod = fwd_prod;
        // Calculate the NEXT product which includes the current self
        fwd_prod *= num;
    }

    // And now iterate backwards to calculate the product AFTER i but still precluding i
    let mut bk_prod: I = num::cast(1).expect(CAST_ERR);
    for (&num, prod) in nums.iter().rev().zip(product.iter_mut().rev()) {
        // Logic here is the same as above. This skips self except in reverse.
        // The product is calculated from right to left (back to front) which fills in the missing
        // products. Remember, iterating forward calculates the cumulative product BEFORE AND
        // PRECLUDING SELF. Therefore, we must iterate backward to calculate the cumulative product
        // AFTER and precluding self.
        *prod *= bk_prod;
        bk_prod *= num;
    }

    product
}

#[cfg(test)]
mod tests {
    use super::prod_sans_self;

    const LEET_TEST_NUMS_01: &[i32] = &[1, 2, 3, 4];
    const LEET_TEST_EXPECTED_01: &[i32] = &[24, 12, 8, 6];
    const LEET_TEST_NUMS_02: &[i32] = &[-1, 1, 0, -3, 3];
    const LEET_TEST_EXPECTED_02: &[i32] = &[0, 0, 9, 0, 0];

    #[test]
    fn prod_sans_self_div_basic_01() {
        let res = prod_sans_self(LEET_TEST_NUMS_01);
        assert!(res.iter().eq(LEET_TEST_EXPECTED_01.iter()))
    }

    #[test]
    fn prod_sans_self_div_basic_02() {
        let res = prod_sans_self(LEET_TEST_NUMS_02);
        assert!(res.iter().eq(LEET_TEST_EXPECTED_02.iter()))
    }
}
