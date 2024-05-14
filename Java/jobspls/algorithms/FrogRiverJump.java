package jobspls.algorithms;

import java.util.Arrays;
import java.util.OptionalInt;
import java.util.TreeSet;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class FrogRiverJump {
    public static OptionalInt frog_jump(int jumps, int[] leaves) {
        var required = new TreeSet<Integer>(IntStream
            .range(1, jumps + 1)
            .boxed()
            .collect(Collectors.toList()));

        var time = 0;
        for (var leaf : leaves) {
            required.remove(leaf);
            if (required.isEmpty()) {
                return OptionalInt.of(time);
            }
            time++;
        }

        return OptionalInt.empty();
    }
}
