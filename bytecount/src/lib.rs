extern crate bytecount;
extern crate libc;
use libc::c_int;
use libc::c_void;
use libc::size_t;
use std::slice;

#[no_mangle]
pub extern "C" fn count_char(bytes: *const c_void, byte: char, len: size_t) -> c_int {
    unsafe {
        let byte_slice = slice::from_raw_parts(bytes as *const u8, len);
        bytecount::count(byte_slice, byte as u8) as c_int
    }
}
