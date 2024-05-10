package jobspls.algorithms;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class UnpairedOccur {
    public static <T> Optional<T> unpaired_occur(T[] haystack) {
        var occur = new HashMap<T, Integer>(haystack.length);
        for (var v : haystack) {
            var count = occur.getOrDefault(v, 0);
            occur.put(v, count + 1);
        }

        return occur.entrySet()
                    .stream()
                    .filter(e -> e.getValue() % 2 != 0)
                    .map(Map.Entry::getKey)
                    .findFirst();
    }
}
