# =============================================================================
# Library: FreeRTOS
#
# Description:
#   CMake support for building FreeRTOS
#
# Usage:
#   add_subdirectory("<path_to_this_file>")
#
# Target Exports:
#   freertos_inc    -- Public headers needed for API usage
#   freertos_core   -- Core library
#   freertos_cm4f   -- Port for the ARM Cortex-M4 with hardware floating point
#   freertos_heap1  -- Library for heap 1
#   freertos_heap2  -- Library for heap 2
#   freertos_heap3  -- Library for heap 3
#   freertos_heap4  -- Library for heap 4
#   freertos_heap5  -- Library for heap 5
#
# Required Project Side Exports:
#   freertos_cfg    -- Has property that includes directory of "FreeRTOSConfig.h"
#   freertos_port   -- Library that selects which port to use from Target Exports
#   freertos_heap   -- Library that selects which heap to use from Target Exports
#
# Project Side Export Examples:
#   add_library(freertos_cfg INTERFACE)
#   target_include_directories(freertos_cfg INTERFACE "<path_to_FreeRTOSConfig.h>")
#   export(TARGETS freertos_cfg FILE "${PROJECT_BINARY_DIR}/ProjectConfig/freertos-cfg.cmake")
#
#   add_library(freertos_port INTERFACE)
#   target_link_libraries(freertos_cfg INTERFACE <freertos_port_lib>)
#   export(TARGETS freertos_port FILE "${PROJECT_BINARY_DIR}/ProjectConfig/freertos-port.cmake")
#
#   add_library(freertos_heap INTERFACE)
#   target_link_libraries(freertos_heap INTERFACE <freertos_heap_lib>)
#   export(TARGETS freertos_heap FILE "${PROJECT_BINARY_DIR}/ProjectConfig/freertos-heap.cmake")
#
# =============================================================================

# ====================================================
# Configure the FreeRTOS project appropriately
# ====================================================
include("${COMMON_TOOL_ROOT}/cmake/options/freertos.cmake")

# ====================================================
# Public Headers
# ====================================================
add_library(freertos_inc INTERFACE)
target_include_directories(freertos_inc INTERFACE "../FreeRTOS/include")

export(TARGETS freertos_inc FILE "${PROJECT_BINARY_DIR}/FreeRTOS/freertos-includes.cmake")

# ====================================================
# Core Library
# ====================================================
add_subdirectory("src")

# ====================================================
# Portable Libraries
# ====================================================
add_subdirectory("portable/GCC/ARM_CM4F")
add_subdirectory("portable/MemMang")
