/** Shuffles a slice in place.
 *
 * @param {Array<T>} slice - Mutable slice to shuffle.
 */
export function shuffle_in_place<T>(slice: Array<T>): void {
  // TypeScript doesn't have unsigned types. This can't underflow.
  let i = slice.length - 1;

  while (i > 0) {
    // Crux of Knuth shuffling.
    // Select a random index up to i, then swap the item at i with it
    const j = Math.floor(Math.random() * i);
    [slice[i], slice[j]] = [slice[j], slice[i]];

    --i;
  }
}
