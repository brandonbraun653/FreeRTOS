include("${COMMON_TOOL_ROOT}/cmake/utility/embedded.cmake")

# ====================================================
# Heap 1
# ====================================================
function(build_heap_1 variant)
  add_library(freertos_heap_1${variant} STATIC
    heap_1.c
  )
  target_link_libraries(freertos_heap_1${variant} PRIVATE
    freertos_inc
    freertos_port
    freertos_cfg
    prj_device_target
    prj_build_target${variant}
  )
  target_compile_definitions(freertos_heap_1${variant} PUBLIC FREERTOS_CFG_MEM_MANG_HEAP1=1)

  export(TARGETS freertos_heap_1${variant} FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos_heap_1${variant}.cmake")
endfunction()

add_target_variants(build_heap_1)

# ====================================================
# Heap 2
# ====================================================
function(build_heap_2 variant)
  add_library(freertos_heap_2${variant} STATIC
    heap_2.c
  )
  target_link_libraries(freertos_heap_2${variant} PRIVATE
    freertos_inc
    freertos_port
    freertos_cfg
    prj_device_target
    prj_build_target${variant}
  )
  target_compile_definitions(freertos_heap_2${variant} PUBLIC FREERTOS_CFG_MEM_MANG_HEAP2=1)

  export(TARGETS freertos_heap_2${variant} FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos_heap_2${variant}.cmake")
endfunction()

add_target_variants(build_heap_2)

# ====================================================
# Heap 3
# ====================================================
function(build_heap_3 variant)
  add_library(freertos_heap_3${variant} STATIC
    heap_3.c
  )
  target_link_libraries(freertos_heap_3${variant} PRIVATE
    freertos_inc
    freertos_port
    freertos_cfg
    prj_device_target
    prj_build_target${variant}
  )
  target_compile_definitions(freertos_heap_3${variant} PUBLIC FREERTOS_CFG_MEM_MANG_HEAP3=1)

  export(TARGETS freertos_heap_3${variant} FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos_heap_3${variant}.cmake")
endfunction()

add_target_variants(build_heap_3)

# ====================================================
# Heap 4
# ====================================================
function(build_heap_4 variant)
  add_library(freertos_heap_4${variant} STATIC
    heap_4.c
  )
  target_link_libraries(freertos_heap_4${variant} PRIVATE
    freertos_inc
    freertos_port
    freertos_cfg
    prj_device_target
    prj_build_target${variant}
  )
  target_compile_definitions(freertos_heap_4${variant} PUBLIC FREERTOS_CFG_MEM_MANG_HEAP4=1)

  export(TARGETS freertos_heap_4${variant} FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos_heap_4${variant}.cmake")
endfunction()

add_target_variants(build_heap_4)

# ====================================================
# Heap 5
# ====================================================
function(build_heap_5 variant)
  add_library(freertos_heap_5${variant} STATIC
    heap_5.c
  )
  target_link_libraries(freertos_heap_5${variant} PRIVATE
    freertos_inc
    freertos_port
    freertos_cfg
    prj_device_target
    prj_build_target${variant}
  )
  target_compile_definitions(freertos_heap_5${variant} PUBLIC FREERTOS_CFG_MEM_MANG_HEAP5=1)

  export(TARGETS freertos_heap_5${variant} FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos_heap_5${variant}.cmake")
endfunction()

add_target_variants(build_heap_5)
