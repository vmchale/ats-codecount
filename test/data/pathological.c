/* block comments don't nest /* */

static int test_format_dir_put(char *dir) {
    snprintf(buf, PATH_MAX, "rm -f %s/*\n", dir);
}

char silly_char(void) {
    // do count this line
    '"' // don't count this line
}
