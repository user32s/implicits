// Copyright 2024 Yandex LLC. All rights reserved.

#include "include/performance_measuring.h"

#include <stdatomic.h>

#define IMPLEMENTATION(SUBJECT)                                             \
  static atomic_uint_fast64_t accumulatorFor##SUBJECT = ATOMIC_VAR_INIT(0); \
  static atomic_uint_fast64_t counterFor##SUBJECT = ATOMIC_VAR_INIT(0);     \
                                                                            \
  void RecordMeasurementFor##SUBJECT(uint64_t ns) {                         \
    atomic_fetch_add_explicit(                                              \
      &accumulatorFor##SUBJECT, ns, memory_order_relaxed                    \
    );                                                                      \
    atomic_fetch_add_explicit(                                              \
      &counterFor##SUBJECT, 1, memory_order_relaxed                         \
    );                                                                      \
  }                                                                         \
                                                                            \
  uint64_t GetAccumulatedMetricFor##SUBJECT(void) {                         \
    return atomic_load(&accumulatorFor##SUBJECT);                           \
  }                                                                         \
                                                                            \
  uint64_t GetCounterFor##SUBJECT(void) {                                   \
    return atomic_load(&counterFor##SUBJECT);                               \
  }

SUBJECT_ENUMERATION(IMPLEMENTATION)
