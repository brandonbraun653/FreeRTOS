# ====================================================
# Core Library
# ====================================================
add_library(freertos_core STATIC
  croutine.c
  event_groups.c
  list.c
  queue.c
  stream_buffer.c
  tasks.c
  timers.c
)
target_link_libraries(freertos_core PRIVATE freertos_inc freertos_port freertos_cfg rtos_build_options)

export(TARGETS freertos_core FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos-core.cmake")
