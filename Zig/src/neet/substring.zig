const expect = @import("std").testing.expect;

/// Check if `sub` is a substring of `s`
///
/// Substrings are position independent. `sub` may exist anywhere in `s`
/// as long as it appears in the correct order.
///
/// `substr` is case sensitive.
pub fn substr(s: []const u8, sub: []const u8) bool {
    // String index
    var si: usize = 0;
    // Substring index
    var subi: usize = 0;

    while (si < s.len and subi < sub.len) : (si += 1) {
        if (s[si] == sub[subi]) {
            subi += 1;
        }
    }

    // Traversing all of `sub` means `s` contains `sub`
    return subi == sub.len;
}

test "substring found in order" {
    const s = "Eeveelution";
    const sub = "Eevee";
    try expect(substr(s, sub));
}
