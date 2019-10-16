.PHONY : bench clean
.DEFAULT_GOAL := target/wc-bench

bytecount/target/release/libbytecount_ffi.so: bytecount/src/lib.rs bytecount/Cargo.toml
	cd bytecount && cargo build --release

target/wc-bench: atspkg.dhall test/wc-bench.dats SATS/wc.sats DATS/wc.dats bytecount/target/release/libbytecount_ffi.so
	atspkg build target/wc-bench

clean:
	rm -rf target *.c bytecount/target bytecount/rusty-tags.vi tags .atspkg

bench: target/wc-bench
	@LD_LIBRARY_PATH=./bytecount/target/release/ ./target/wc-bench
