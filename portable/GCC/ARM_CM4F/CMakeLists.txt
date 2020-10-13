# ====================================================
# Library for the Cortex-M4 FreeRTOS port
# ====================================================
add_library( freertos_cm4f STATIC
  arm_cm4f_port.c
)
target_link_libraries(freertos_cm4f PRIVATE freertos_inc freertos_cfg rtos_build_options)
target_include_directories(freertos_cm4f PUBLIC ".")
target_compile_definitions(freertos_cm4f PUBLIC FREERTOS_CFG_PORT_ARM_CM4F=1)

export(TARGETS freertos_cm4f FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos-cm4f.cmake")
