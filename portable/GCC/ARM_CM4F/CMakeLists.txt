include("${COMMON_TOOL_ROOT}/cmake/utility/embedded.cmake")

# ====================================================
# Library for the Cortex-M4 FreeRTOS port
# ====================================================
function(build_cm4f variant)
  add_library(freertos_cm4f${variant} STATIC
    arm_cm4f_port.c
  )
  target_link_libraries(freertos_cm4f${variant} PRIVATE freertos_inc freertos_cfg prj_device_target prj_build_target${variant})
  target_include_directories(freertos_cm4f${variant} PUBLIC ".")
  target_compile_definitions(freertos_cm4f${variant} PUBLIC FREERTOS_CFG_PORT_ARM_CM4F=1)
  export(TARGETS freertos_cm4f${variant} FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos-cm4f${variant}.cmake")
endfunction()

add_target_variants(build_cm4f)
