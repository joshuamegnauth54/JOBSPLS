const sort_str = (s: string): string =>
  s
    .split("")
    .sort((a, b) => a.localeCompare(b))
    .join("");

export default async function is_anagram(
  s1: string,
  s2: string,
): Promise<boolean> {
  const s1_sort = sort_str(s1);
  const s2_sort = sort_str(s2);

  // Encode to a bytes buffer
  const encoder = new TextEncoder();
  const s1_buf = encoder.encode(s1_sort);
  const s2_buf = encoder.encode(s2_sort);

  // Hash both strings
  const [s1_res, s2_res] = await Promise.all([
    crypto.subtle.digest("SHA-256", s1_buf),
    crypto.subtle.digest("SHA-256", s2_buf),
  ]);
  const decoder = new TextDecoder();
  const s1_hash = decoder.decode(s1_res);
  const s2_hash = decoder.decode(s2_res);
  return s1_hash === s2_hash;
}
