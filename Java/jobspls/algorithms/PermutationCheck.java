package jobspls.algorithms;

import java.util.Arrays;
import java.util.TreeSet;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class PermutationCheck {
    public static boolean perm_check(int[] haystack) {
        var numbers = new TreeSet<Integer>(Arrays
            .stream(haystack)
            .boxed()
            .collect(Collectors.toList()));

        return IntStream.range(1, haystack.length + 1)
                        .allMatch(n -> { return numbers.contains(n); });
    }
}
