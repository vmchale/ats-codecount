extern crate bytecount;

#[macro_use]
extern crate criterion;

use criterion::Criterion;

use std::fs::File;
use std::io::prelude::*;

fn file_lines_nobuf(fp: &str) -> usize {
    let mut f = File::open(fp).unwrap();
    let mut buffer = String::new();

    f.read_to_string(&mut buffer).unwrap();
    bytecount::count(&buffer.as_bytes(), b'\n')
}

fn file_lines(fp: &str) -> usize {
    let mut f = File::open(fp).unwrap();
    let mut buffer = [0; 32 * 1024];
    let mut linecount = 0;
    loop {
        let read_result = f.read(&mut buffer).unwrap();
        match read_result {
            0 => break,
            res => {
                let sub_buffer = &buffer[0..res];
                linecount = linecount + bytecount::count(&sub_buffer, b'\n');
            }
        };
    }
    linecount
}

fn buffered_benchmark(c: &mut Criterion) {
    c.bench_function("bytecount (sqlite3.c)", |b| {
        b.iter(|| file_lines("../test/data/sqlite3.c"))
    });
}

fn unbuffered_benchmark(c: &mut Criterion) {
    c.bench_function("bytecount (unbuffered) (sqlite3.c)", |b| {
        b.iter(|| file_lines_nobuf("../test/data/sqlite3.c"))
    });
}
criterion_group!(benches, buffered_benchmark, unbuffered_benchmark);
criterion_main!(benches);
