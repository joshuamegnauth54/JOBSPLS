// Vector
#ifndef JOSH_COLLECTIONS_VECTOR_H
#define JOSH_COLLECTIONS_VECTOR_H

#include <stddef.h>
#include <stdbool.h>
#include <sys/types.h>

// Growable, managed slice (array).
//
// This implementation can use `memcpy_s` if __STDC_WANT_LIB_EXT1__
// is defined and set to 1.
// A constraint handler may be registered to handle `memcpy_s` violations.
//
// https://en.cppreference.com/w/c/error/set_constraint_handler_s
//
// Some inspiration from: https://blog.phundrak.com/writing-dynamic-vector-c/
struct Vector {
  // Capacity of `data` in terms of how many T may be stored
  size_t capacity;
  // Number of type T stored in `data` (a.k.a. length)
  size_t pos;
  // Size of type T
  size_t const data_size;
  // Array of size `len` to any type, T
  u_int8_t *data;
};

enum VectorErrors {
  // Item not found
  NOITEM
};

// Create a new Vector that stores data of size `data_size`.
//
// # Arguments
// * data_size: Size of type T in bytes.
//   For example:
//               1. int32 values are 4 bytes
//               2. Pointers to anything are the size of the pointer
//               3. A struct is the size of the struct value
struct Vector *vec_new(size_t const data_size);

// Construct a Vector that holds at least `cap` items before allocating
struct Vector *vec_with_capacity(size_t const data_size, size_t const cap);

__attribute__((nonnull)) void vec_free(struct Vector *const self);

// Delete a Vector and call a function on each value for clean up.
//
// NOTE: `drop` is called on every element of the vector to clean up resources.
// Ownership is transferred to `drop`.
// Therefore, `drop` must deallocate memory if necessary.
__attribute__((nonnull)) void vec_free_with(struct Vector *const self,
                                            void drop(void *const));

// Map T => U
//
// `map` must not modify its argument in any way.
__attribute__((nonnull)) struct Vector *vec_map(struct Vector const *const self,
                                                size_t const U_data_size,
                                                void *map(void const *const));

// Push `value` to the end of the Vector, resizing if necessary.
//
// Returns NULL on error.
__attribute__((nonnull)) bool vec_push(struct Vector *const self,
                                       void const *const value);

// Pop the last value from the end of the Vector.
//
// Returns NULL if empty.
__attribute__((nonnull)) void *vec_pop(struct Vector *const self);

// Retrieves the bytes at `index` (unchecked).
//
// WARNING: Validity isn't checked at all.
__attribute__((nonnull)) void *vec_at(struct Vector const *const self,
                                      size_t const index);

// Safely retrieves the bytes/object at `index`.
//
// Returns `NULL` is `index` is out of bounds.
__attribute__((nonnull)) void *vec_get(struct Vector const *const self,
                                       size_t const index);

// Removes and returns the bytes/object at `index`.
//
// WARNING: Unchecked and unsafe.
__attribute__((nonnull)) void *vec_remove(struct Vector *const self,
                                          size_t const index);

__attribute__((nonnull)) void* vec_remove_safe(struct Vector* const self, size_t const index);

// Resize vector to hold N items
// * N should be > 0
// * N < vector length discards items
// * N > vector length reserves capacity
//
// Discarded items aren't cleaned up in any way. They just go poof.
__attribute__((nonnull)) bool vec_resize(struct Vector *const self,
                                         size_t const n_items);

// Shrink vector so that it holds exactly the capacity.
__attribute__((nonnull)) bool vec_shrink(struct Vector *const self);

// Reserve space for `n_items` total elements.
//
// `n_items` should be > 0 and > capacity.
__attribute__((nonnull)) bool vec_reserve(struct Vector *const self,
                                          size_t const n_items);

#endif
