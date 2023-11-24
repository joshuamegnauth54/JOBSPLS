#define __STDC_WANT_LIB_EXT1__ 1

#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

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

__attribute__((nonnull)) void vec_free_with(struct Vector *const self,
                                            void drop(void *const)) {
  // Drop each valid entry
  for (size_t i = 0; i < self->pos; ++i) {
    u_int8_t *const item = vec_at(self, i);
    drop(item);
  }

  // And then free the vector
  vec_free(self);
}

__attribute__((nonnull)) struct Vector *vec_map(struct Vector const *const self,
                                                size_t const U_data_size,
                                                void *map(void const *const)) {
  struct Vector *const other = vec_with_capacity(U_data_size, self->capacity);
  if (!other) {
    return NULL;
  }

  // Map every item in self to U
  for (size_t i = 0; i < self->pos; ++i) {
    void const *const T_item = vec_at(self, i);

    // T => U
    void const *const U_item = map(T_item);
    vec_push(other, U_item);
  }

  return other;
}

__attribute__((nonnull)) bool vec_push(struct Vector *const self,
                                       void const *const value) {
  // `pos` starts at 0, so `pos` == `cap` means the vector should be resized
  if (self->pos == self->capacity) {
    size_t const new_cap = self->capacity * 2;
    if (!vec_reserve(self, new_cap)) {
      return false;
    }

    self->capacity = new_cap;
  }

  // Copy `value` into the buffer.
  void *const current = vec_at(self, self->pos);

// Use memcpy_s if available
#ifdef __STD_LIB_EXT1__

#else

#endif

  self->pos++;
  return true;
}
