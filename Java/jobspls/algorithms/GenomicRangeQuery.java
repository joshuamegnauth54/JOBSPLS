package jobspls.algorithms;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class GenomicRangeQuery {
    public static List<Integer> range_query(String genome, int[] p, int[] q) {
        var prefix = new int[4];
        var prefixes = genome
            .chars()
            .boxed()
            .map(nucleotide -> {
                var sum = prefix.clone();

                switch(nucleotide) {
                    case (int) 'A':
                        sum[0] += 1;
                        System.arraycopy(sum, 0, prefix, 0, prefix.length);
                        break;
                    case (int) 'C':
                        sum[1] += 1;
                        System.arraycopy(sum, 0, prefix, 0, prefix.length);
                        break;
                    case (int) 'G':
                        sum[2] += 1;
                        System.arraycopy(sum, 0, prefix, 0, prefix.length);
                        break;
                    case (int) 'T':
                        sum[3] += 1;
                        System.arraycopy(sum, 0, prefix, 0, prefix.length);
                        break;
                    default:
                        throw new IllegalArgumentException(String.format("Expected one of: {A C G T} but got %c", nucleotide));
                }

                return sum;
            })
            .collect(Collectors.toList());

        return IntStream
            .range(0, p.length)
            .map(i -> {
                var j = p[i];
                var k = q[i];
                var lower = prefixes.get(j);
                var upper = prefixes.get(k);

                for (var l = 0; l < 4; l++) {
                    var diff = upper[l] - lower[l];
                    if (diff > 0) {
                        return l + 1;
                    }
                }

                return 0;
            })
            .boxed()
            .collect(Collectors.toList());
    }
}
