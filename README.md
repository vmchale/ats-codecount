# ats-wc

Benchmark of the [bytecount](https://docs.rs/bytecount/) library compared to
simply using a `for*` loop and GCC.

## Conclusions

```
sqlite.c (for loop)
    estimate: 1.061150 ms
sqlite.c (bytecount)
    estimate: 1.169256 ms
```

As can be seen, bytecount achieves acceptable (though not particularly
impressive) performance; these benchmarks were performed on x86\_64.
