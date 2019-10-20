vtypedef file = @{ lines = int, blanks = int, comments = int, doc_comments = int }

val empty_file: file

fn file_eq(file, file) : bool

fn add_file(file, file) : file

fn file_tostring(file) : string

overload + with add_file
overload = with file_eq
