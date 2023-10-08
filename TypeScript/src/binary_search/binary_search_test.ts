import {
  assertExists,
  assertObjectMatch,
  assertStrictEquals,
} from "../dev_deps.ts";
import binary_search from "./binary_search.ts";

const numbers = [...Array(100).keys()];

Deno.test("test finding 14 in [0,100)", () => {
  const found = binary_search(numbers, 14);
  assertExists(found, "found_idx");
  assertStrictEquals(found.found_idx, 14);
});

Deno.test("test finding 100 in [0,100)", () => {
  const found = binary_search(numbers, 100);
  assertObjectMatch(found, { missing_idx: 99 });
});

Deno.test("test finding -1 in [0,100)", () => {
  const found = binary_search(numbers, -1);
  assertObjectMatch(found, { missing_idx: 0 });
});

Deno.test("test finding 14 in {}", () => {
  const empty: Array<number> = [];
  const found = binary_search(empty, 14);
  assertObjectMatch(found, { missing_idx: 0 });
});
