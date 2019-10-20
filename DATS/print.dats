staload "libats/ML/SATS/string.sats"
staload "SATS/file.sats"

implement file_tostring (f) =
  "Lines: "
  + tostring_int(f.lines + f.blanks + f.comments + f.doc_comments)
  + " Code: "
  + tostring_int(f.lines)
  + " Blanks: "
  + tostring_int(f.blanks)
  + " Comments: "
  + tostring_int(f.comments)
