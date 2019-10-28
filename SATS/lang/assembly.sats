// deal with these fucking horrible character escapes: https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_3.html#SEC32
// https://stackoverflow.com/questions/33246811/how-to-use-character-literals-in-gnu-gas-to-replace-numbers
datavtype parse_state_as =
  | line_comment
  | in_string
  | post_backslash_in_string
  | in_block_comment
  | post_slash
  | post_asterisk_in_block_comment
  | post_block_comment
  | regular
  | post_newline_whitespace
  | line_comment_regular
  | in_block_comment_line_end
  | post_slash_regular
  | post_asterisk_in_block_comment_line_end
  | post_tick
  | maybe_close_char
  | in_char
  | post_char_backslash

fn parse_state_as_tostring(st : &parse_state_as >> _) : string

fn free_st_as(parse_state_as) : void

overload free with free_st_as
