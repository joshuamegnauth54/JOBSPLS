#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "vector.h"

#define VEC_DEFAULT_CAP 8

// Size of N items
static inline size_t size_of_n(size_t const size, size_t const n) {
  return size * n;
}

struct Vector *vec_new(size_t const data_size) {
  // Delegate to with_capacity
  return vec_with_capacity(data_size, VEC_DEFAULT_CAP);
}

struct Vector *vec_with_capacity(size_t const data_size, size_t const cap) {
  if (!data_size || !cap) {
    return NULL;
  }

  // Can't assign to self->data_size which is const
  // Casting away const is UB
  // Solution: memcpy temp_self
  struct Vector temp_self = {.capacity = cap,
                             .pos = 0,
                             .data_size = data_size,
                             .data =
                                 (u_int8_t *)malloc(size_of_n(data_size, cap))};

  // Clean up after failed alloc
  if (!temp_self.data) {
    return NULL;
  }

  // Copy initialized struct to self
  struct Vector *self = (struct Vector *)malloc(sizeof(struct Vector));
  if (!self) {
    return NULL;
  }

  memcpy(self, &temp_self, sizeof(struct Vector));

  return self;
}

__attribute__((nonnull)) void vec_free(struct Vector *const self) {
  free(self->data);
  free(self);
}
