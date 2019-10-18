# ats-wc

Benchmark of the [bytecount](https://docs.rs/bytecount/) library compared to
a `for*` loop and GCC.

## Conclusions

```
bytecount (sqlite3.c)   time:   [702.49 us 705.48 us 708.89 us]
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

## Building

To replicate the benchmarks, you will need
[ats-pkg](http://hackage.haskell.org/package/ats-pkg),
[cabal-install](https://www.haskell.org/cabal/download.html),
[GHC](https://www.haskell.org/ghcup/), and [cargo](https://rustup.rs/). Then:

```
./shake.hs bench
```

Results will vary based on the CPU; exotic architectures may see
completely different results.

I used `rustc` 1.38.0 and GCC 9.2.0.
