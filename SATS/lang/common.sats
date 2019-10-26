staload "SATS/file.sats"

fn {a:vt@ype} advance_char$lang (char, &a >> _, &file >> _) : void

fn {a:vt@ype} free$lang (a) : void

fn {a:vt@ype} init$lang (&a? >> a) : void

fn {a:vt@ype} filecount (string) : void

fn {a:vt@ype} file$lang (string) : Option_vt(file)
