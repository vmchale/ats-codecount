extern crate bytecount;
extern crate libc;
use libc::c_void;
use libc::size_t;
use std::slice;

#[no_mangle]
pub extern "C" fn count_lines(bytes: *const c_void, len: size_t) -> size_t {
    unsafe {
        let byte_slice = slice::from_raw_parts(bytes as *const u8, len);
        bytecount::count(byte_slice, b'\n')
    }
}
