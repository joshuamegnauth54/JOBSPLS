package jobspls.algorithms;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Cyclic {
    @SuppressWarnings("unchecked")
    public static <T> List<T> rotate(T[] values, int by) {
        var rotated = new Object[values.length];

        for (var i = 0; i < values.length; ++i) {
            var j = (i + by) % values.length;
            rotated[j] = values[i];
        }

        // NOTE: Type must be T because the function takes an array of T
        return Arrays.stream(rotated)
                     .map(v -> { return (T) v; })
                     .collect(Collectors.toList());
    }
}
