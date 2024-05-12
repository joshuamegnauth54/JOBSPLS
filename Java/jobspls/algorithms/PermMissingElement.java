package jobspls.algorithms;

import java.util.Arrays;
import java.util.TreeSet;

import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class PermMissingElement {
    public static int missing_element(int[] haystack) {
        var hayset = new TreeSet<Integer>(Arrays.stream(haystack)
                                                .boxed()
                                                .collect(Collectors.toList()));

        // Should always find a value.
        return IntStream.range(1, haystack.length + 2)
                        .filter(n -> { return !hayset.contains(n); })
                        .findFirst()
                        .getAsInt();
    }
}
