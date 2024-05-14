package jobspls.algorithms;

import java.util.Arrays;
import java.util.HashSet;
import java.util.OptionalInt;
import java.util.stream.IntStream;
import java.util.stream.Collectors;

public class SmallestPositiveInteger {
    public static OptionalInt calculate(int[] haystack) {
        var hayset = new HashSet<Integer>(IntStream.of(haystack)
                                                   .boxed()
                                                   .collect(Collectors.toList()));

        return IntStream.range(1, Integer.MAX_VALUE)
                        .filter(n -> { return !hayset.contains(n); })
                        .findFirst();
    }
}
