include("${COMMON_TOOL_ROOT}/cmake/utility/embedded.cmake")

# ====================================================
# Core Library
# ====================================================
function(build_core variant)
  add_library(freertos_core${variant} STATIC
    croutine.c
    event_groups.c
    list.c
    queue.c
    stream_buffer.c
    tasks.c
    timers.c
  )

  target_link_libraries(freertos_core${variant} PRIVATE
    freertos_inc
    freertos_port
    freertos_cfg
    prj_device_target
    prj_build_target${variant}
  )

  export(TARGETS freertos_core${variant} FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos_core${variant}.cmake")
endfunction()

add_target_variants(build_core)
