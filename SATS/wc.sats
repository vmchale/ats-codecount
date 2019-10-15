vtypedef file = @{ lines = int, blanks = int, comments = int, doc_comments = int }

datavtype parse_state =
  | in_string
  | in_block_comment
  | line_comment
  | regular

val empty_file: file

fn add_file(f0 : !file, f1 : !file) : file

overload + with add_file

fn count_buf {l:addr}{m:nat} (!bytes_v(l, m) | ptr(l), &parse_state >> _) : file

fn count_lines {l:addr}{m:nat} (!bytes_v(l, m) | ptr(l)) : int

fn count_file(fp : !FILEptr1) : file
