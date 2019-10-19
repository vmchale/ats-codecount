staload "libats/ML/SATS/string.sats"
staload "SATS/wc.sats"

implement file_to_string (f) =
  "Lines: "
  + tostring_int(f.lines)
  + " Blanks: "
  + tostring_int(f.blanks)
  + " Comments: "
  + tostring_int(f.comments)
