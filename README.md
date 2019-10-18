# ats-wc

Benchmark of the [bytecount](https://docs.rs/bytecount/) library compared to
simply using a `for*` loop and GCC.

## Conclusions

```
bytecount (sqlite3.c)   time:   [702.49 us 705.48 us 708.89 us]
                        change: [-1.3521% -1.0614% -0.7512%] (p = 0.00 < 0.05)
                        Change within noise threshold.
Found 10 outliers among 100 measurements (10.00%)
  1 (1.00%) low mild
  6 (6.00%) high mild
  3 (3.00%) high severe

sqlite.c (for loop)
    estimate: 622.847476 μs
sqlite.c (bytecount)
    estimate: 701.477035 μs
```

As can be seen, bytecount achieves acceptable performance; these
benchmarks were performed on x86\_64.
