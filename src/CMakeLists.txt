include(CTEmbedded)

gen_static_lib_variants(
  TARGET
    freertos_core
  SOURCES
    croutine.c
    event_groups.c
    list.c
    queue.c
    stream_buffer.c
    tasks.c
    timers.c
  PRV_LIBRARIES
    freertos_intf_inc_all
  EXPORT_DIR
    "${PROJECT_BINARY_DIR}/FreeRTOS"
)
