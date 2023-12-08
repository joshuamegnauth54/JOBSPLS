#define __STDC_WANT_LIB_EXT1__ 1

#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#include "vector.h"

#define VEC_DEFAULT_CAP 8

// Size of N items
// (Why did I write this function?)
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
  // `current` refers to uninitialized bytes
  void *const current = vec_at(self, self->pos);

// Use memcpy_s if available
#ifdef __STD_LIB_EXT1__
  int const err = memcpy_s(current, self->data_size, value, self->data_size);
  if (err != 0) {
    return false;
  }
#else
  memcpy(current, value, self->data_size);
#endif

  self->pos++;
  return true;
}

__attribute__((nonnull)) void *vec_pop(struct Vector *const self) {
  // Vector is empty if pos == 0
  if (self->pos) {
    return vec_remove(self, self->pos - 1);
  }

  return NULL;
}

__attribute__((nonnull)) void *vec_at(struct Vector const *const self,
                                      size_t const index) {
  return &self->data[self->data_size * index];
}

// `vec_get` is just `vec_at` with a check.
__attribute__((nonnull)) void *vec_get(struct Vector const *const self,
                                       size_t const index) {
  if (index > self->pos) {
    return NULL;
  }

  return vec_at(self, index);
}

__attribute__((nonnull)) void *vec_remove(struct Vector *const self,
                                          size_t const index) {
  // Vec is empty if pos == 0
  if (self->pos && index < self->pos) {
    // Move the object from the vector to these allocated bytes
    // Caller owns the memory
    u_int8_t *obj_moved = malloc(self->data_size);
    if (!obj_moved) {
      return NULL;
    }

    // Object to copy
    u_int8_t *obj_vec = &self->data[self->data_size * index];

    // Use memcpy_s if available
#ifdef __STD_LIB_EXT1__
    int err = memcpy_s(obj_moved, self->data_size, obj_vec, self->data_size);
    if (err) {
      free(obj_moved);
      return NULL;
    }
#else
    memcpy(obj_moved, obj_vec, self->data_size);
#endif

    if (index != self->pos - 1) {
      // Amount of bytes to copy
      // If pos == 1 or index == 0 then copy_size can be 0 or overflow
      size_t const copy_size = (self->pos != 1 && index > 0)
                                   ? self->data_size * (self->pos - index - 1)
                                   : self->data_size;

#ifdef __STD_LIB_EXT1__
      err = memcpy_s(vec_at(self, index), copy_size, vec_at(self, index + 1),
                     copy_size);
      if (err) {
        free(obj_moved);
        return NULL;
      }
#else
      memcpy(vec_at(self, index), vec_at(self, index + 1), copy_size);
#endif
    }
    self->pos--;

    return obj_moved;
  }

  return NULL;
}

__attribute__((nonnull)) bool vec_resize(struct Vector *const self,
                                         size_t const n_items) {
  if (n_items == 0) {
    return false;
  }

  // Try realloc
  // `realloc` returns NULL on error or a possibly new address
  // on success.
  void *new_data = reallocarray(self->data, n_items, self->data_size);
  if (!new_data) {
    // Original pointer is left alone. Caller decides what to do.
    return false;
  }

  // Original pointer is invalid and doesn't need to be freed.
  self->data = new_data;
  self->capacity = n_items;
  return true;
}

__attribute__((nonnull)) bool vec_shrink(struct Vector *const self) {
  return vec_resize(self, self->capacity);
}

__attribute__((nonnull)) bool vec_reserve(struct Vector *const self,
                                          size_t const additional) {
  return vec_resize(self, self->capacity + additional);
}
