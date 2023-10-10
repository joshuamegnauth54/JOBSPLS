use std::num::NonZeroUsize;

#[allow(clippy::needless_lifetimes)]
pub fn concat_slice<'slice, T: Clone>(
    slice: &'slice [T],
    amount: NonZeroUsize,
) -> impl Iterator<Item = T> + 'slice {
    slice
        .iter()
        .cloned()
        .cycle()
        .take(amount.get() * slice.len())
}

#[cfg(test)]
mod tests {
    use super::concat_slice;

    #[derive(Clone, PartialEq, Eq)]
    struct Person {
        name: String,
    }

    #[test]
    fn repeat_slice_success() {
        let emi = Person {
            name: "Emi".to_owned(),
        };

        let two_emis = [emi.clone(), emi];
        let emi_army: Vec<_> = concat_slice(&two_emis, 4.try_into().unwrap()).collect();

        assert_eq!(emi_army.len(), 8);
        assert!(emi_army.iter().all(|an_emi| *an_emi == two_emis[0]))
    }
}
