# ====================================================
# Heap 1
# ====================================================
add_library( freertos_heap1 STATIC
  heap_1.c
)
target_link_libraries(freertos_heap1 PRIVATE freertos_inc freertos_port freertos_cfg prj_device_target)
target_compile_definitions(freertos_heap1 PUBLIC FREERTOS_CFG_MEM_MANG_HEAP1=1)

export(TARGETS freertos_heap1 FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos-heap1.cmake")

# ====================================================
# Heap 2
# ====================================================
add_library( freertos_heap2 STATIC
  heap_2.c
)
target_link_libraries(freertos_heap2 PRIVATE freertos_inc freertos_port freertos_cfg prj_device_target)
target_compile_definitions(freertos_heap2 PUBLIC FREERTOS_CFG_MEM_MANG_HEAP2=1)

export(TARGETS freertos_heap2 FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos-heap2.cmake")

# ====================================================
# Heap 3
# ====================================================
add_library( freertos_heap3 STATIC
  heap_3.c
)
target_link_libraries(freertos_heap3 PRIVATE freertos_inc freertos_port freertos_cfg prj_device_target)
target_compile_definitions(freertos_heap3 PUBLIC FREERTOS_CFG_MEM_MANG_HEAP3=1)

export(TARGETS freertos_heap3 FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos-heap3.cmake")

# ====================================================
# Heap 4
# ====================================================
add_library( freertos_heap4 STATIC
  heap_4.c
)
target_link_libraries(freertos_heap4 PRIVATE freertos_inc freertos_port freertos_cfg prj_device_target)
target_compile_definitions(freertos_heap4 PUBLIC FREERTOS_CFG_MEM_MANG_HEAP4=1)

export(TARGETS freertos_heap4 FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos-heap4.cmake")

# ====================================================
# Heap 5
# ====================================================
add_library( freertos_heap5 STATIC
  heap_5.c
)
target_link_libraries(freertos_heap5 PRIVATE freertos_inc freertos_port freertos_cfg prj_device_target)
target_compile_definitions(freertos_heap5 PUBLIC FREERTOS_CFG_MEM_MANG_HEAP5=1)

export(TARGETS freertos_heap5 FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos-heap5.cmake")