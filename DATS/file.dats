staload "SATS/file.sats"

implement file_eq (f0, f1) =
  f0.lines = f1.lines && f0.blanks = f1.blanks && f0.comments = f1.comments && f0.doc_comments = f1.doc_comments

implement empty_file =
  @{ lines = 0, blanks = 0, comments = 0, doc_comments = 0 } : file

implement add_file (f0, f1) =
  @{ lines = f0.lines + f1.lines
   , blanks = f0.blanks + f1.blanks
   , comments = f0.comments + f1.comments
   , doc_comments = f0.doc_comments + f1.doc_comments
   } : file
