#include <stddef.h>
#include <stdatomic.h>

struct stack_t {
    void *value;
    struct stack_t *next;
};

void stack_init(struct stack_t *st) {
    st->value = NULL;
    st->next = NULL;
}

void push(struct stack_t *st, void *val) {
    for (;;) {
        struct stack_t *old_st = st;
        struct stack_t new_st = {val, old_st};
        if (atomic_compare_exchange_strong(&st, &old_st, &new_st))
            return;
    }
}

void *pop(struct stack_t *st) {
    for (;;) {
        struct stack_t *old_st = st;
        if (st->next == NULL && st->value == NULL)
            return NULL;
        struct stack_t *xs1 = st->next;
        void *x = st->value;
        if (atomic_compare_exchange_strong(&st, &old_st, xs1))
            return x;
    }
}
