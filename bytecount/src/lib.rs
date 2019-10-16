extern crate bytecount;
extern crate libc;
extern crate memchr;

use libc::c_int;
use libc::c_uint;
use libc::size_t;
use std::slice;

#[no_mangle]
pub extern "C" fn memchr2(bytes: *const u8, b0: char, b1: char, bufsz: size_t) -> Option<c_uint> {
    unsafe {
        let byte_slice = slice::from_raw_parts(bytes, bufsz);
        memchr::memchr2(b0 as u8, b1 as u8, byte_slice).map(|x| x as c_uint)
    }
}

#[no_mangle]
pub extern "C" fn memchr3(bytes: *const u8, b0: char, b1: char, b2: char, bufsz: size_t) -> Option<c_uint> {
    unsafe {
        let byte_slice = slice::from_raw_parts(bytes, bufsz);
        memchr::memchr3(b0 as u8, b1 as u8, b2 as u8, byte_slice).map(|x| x as c_uint)
    }
}

#[no_mangle]
pub extern "C" fn count_char(bytes: *const u8, byte: char, len: size_t) -> c_int {
    unsafe {
        let byte_slice = slice::from_raw_parts(bytes, len);
        bytecount::count(byte_slice, byte as u8) as c_int
    }
}
