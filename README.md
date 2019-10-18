# ats-wc

Benchmark of the [bytecount](https://docs.rs/bytecount/) library compared to
simply using a `for*` loop and GCC.

## Conclusions

```
Benchmarking bytecount (sqlite3.c): Warming up for 3.0000 s
bytecount (sqlite3.c)   time:   [1.1238 ms 1.1324 ms 1.1409 ms]
                        change: [-1.1963% +0.1606% +1.4871%] (p = 0.81 > 0.05)
                        No change in performance detected.
Found 5 outliers among 100 measurements (5.00%)
  2 (2.00%) high mild
  3 (3.00%) high severe

sqlite.c (for loop)
    estimate: 1.057770 ms
sqlite.c (bytecount)
    estimate: 1.145262 ms
```

As can be seen, bytecount achieves acceptable (though not particularly
impressive) performance; these benchmarks were performed on x86\_64.
