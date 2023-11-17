mod anagram;
mod concat;
mod consec_sequence;
mod containsdupes;
mod group_anagrams;
mod kth_largest;
mod last_word_len;
mod longest_prefix;
mod prod_sans_self;
mod replace_vals_right;
mod substring;
mod two_sum;
mod two_sum_ordered;
mod valid_palindrome;

pub use anagram::{anagram, anagram_alt};
pub use concat::concat_slice;
pub use consec_sequence::{consec_sequence_heap, consec_sequence_set};
pub use containsdupes::contains_dupes;
pub use group_anagrams::group_anagrams;
pub use kth_largest::kth_largest;
pub use last_word_len::last_word_len;
pub use longest_prefix::longest_prefix;
pub use prod_sans_self::prod_sans_self;
pub use replace_vals_right::replace_vals_right;
pub use substring::substring;
pub use two_sum::two_sum;
pub use two_sum_ordered::two_sum_ordered;
pub use valid_palindrome::valid_palindrome;

// Utilities
#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Debug)]
pub struct SeqPos {
    pub i: usize,
    pub j: usize,
}
