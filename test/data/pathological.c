/* block comments don't nest /* */

#include <stdio.h>

static int test_format_dir_put(char *dir) {
    snprintf(buf, PATH_MAX, "rm -f %s/*\n", dir);
}

char silly_char(void) {
    // do count this line
    return '"'; // don't count this line
}

int always_return_zero(void) { /* begin comment
                                  second bit of comment
                                  */


    return 0;
}

void silly_switch(char c) {
    switch (c) {
    case '"':
        break;
    // Comment
    default:
        break;
    }
}
