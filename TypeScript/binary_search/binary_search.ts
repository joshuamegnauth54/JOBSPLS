export interface SearchResult {
  // Index if found
  found_idx?: number;
  // Location near where the element should be if appropriately placed
  missing_idx?: number;
}

export default function binary_search<T>(vec: Array<T>, find: T): SearchResult {
  let lower = 0;
  let upper = vec.length - 1;
  let index = 0;

  while (lower <= upper) {
    index = Math.floor((lower + upper) / 2);

    if (vec[index] < find) {
      lower = index + 1;
    } else if (vec[index] > find) {
      upper = index - 1;
    } else {
      return { found_idx: index };
    }
  }

  return { missing_idx: index };
}
