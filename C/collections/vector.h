// Vector
#ifndef JOSH_COLLECTIONS_VECTOR_H
#define JOSH_COLLECTIONS_VECTOR_H

#include <stddef.h>
#include <sys/types.h>

struct Vector {
    // Capacity of `data` in terms of how many T may be stored
    size_t capacity;
    // Number of type T stored in `data` (a.k.a. length)
    size_t pos;
    // Size of type T
    size_t const data_size;
    // Array of size `len` to any type, T
    u_int8_t* data;
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
Vector* vec_new(size_t const data_size);

Vector* vec_with_capacity(size_t const data_size, size_t const cap);

__attribute__((nonnull))
void vec_free(Vector* const vec);

// Delete a Vector and call a function on each value for clean up.
//
// NOTE: dfree should be cognizant of type T as each value is passed as is.
// T may be the value of pointers or structs by value.
// The caller should know the type.
void vec_free_with(Vector* const vec, void dfree(void*));

// Map T => U
__attribute__((nonnull))
Vector* vec_map(Vector const* const vec, size_t const data_size, void* map(void*));

__attribute__((nonnull))
void vec_push(Vector* const vec, void const* const value);

__attribute__((nonnull))
void* vec_pop(Vector* const vec);

__attribute__((nonnull))
void* vec_get(Vector const* const vec, size_t const index);

__attribute__((nonnull))
void* vec_remove(Vector* const vec, size_t const index);

#endif
