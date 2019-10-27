// Line comment
fn return_str() -> &'static str {
    r###"
    This is a raw string literal.

    #"

    // This should not be counted as a comment.
    /* nor should this!
    "###
}

fn return_char() -> char {
    '"'
} /* first line of block comment
  second line of block comment */

/* nested /* block comment */ */

/***/
