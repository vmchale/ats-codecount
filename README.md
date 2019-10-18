# ats-wc

Benchmark of the [bytecount](https://docs.rs/bytecount/) library compared to
simply using a `for*` loop and GCC.

## Conclusions

```
bytecount (sqlite3.c)   time:   [707.15 us 708.12 us 709.10 us]                                  
Found 4 outliers among 100 measurements (4.00%)
  3 (3.00%) high mild
  1 (1.00%) high severe

sqlite.c (for loop)
    estimate: 619.777896 μs
sqlite.c (bytecount)
    estimate: 701.243583 μs
Build completed in 1m08s
```

As can be seen, bytecount achieves acceptable performance; these
benchmarks were performed on x86\_64.
