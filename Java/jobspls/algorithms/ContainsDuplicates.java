package jobspls.algorithms;

import java.util.Arrays;
import java.util.HashSet;
import java.util.stream.Collectors;

public class ContainsDuplicates {
    public static <T> boolean contains_duplicates(T[] haystack) {
        var hayset = new HashSet<T>(Arrays
            .stream(haystack)
            .collect(Collectors.toList()));

        return hayset.size() != haystack.length;
    }
}
