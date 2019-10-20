fn freadc { l : addr | l != null }{ sz : nat | sz >= 1 } (pf : !bytes_v(l, sz)
                                                         | inp : !FILEptr1, bufsize : size_t(sz), p : ptr(l)) : size_t
