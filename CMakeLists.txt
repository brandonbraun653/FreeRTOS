cmake_minimum_required(VERSION 3.12.2)

# --------------------------------------
# Grab any global properties needed 
# --------------------------------------
get_property(STM32_CMAKE_TOOLS GLOBAL PROPERTY STM32_CMAKE_TOOLS_DIR)
get_property(STM32_DEVICE_FAMILY GLOBAL PROPERTY STM32_DEVICE_FAMILY)
get_property(STM32_COMPILER_OPTIONS GLOBAL PROPERTY STM32_COMPILER_OPTIONS)

# Make sure we use a decent memory management strategy
if(NOT FREERTOS_MEMMANG_TYPE)
    set(FREERTOS_MEMMANG_NAME "heap_4")
else()
    set(FREERTOS_MEMMANG_NAME "heap_${FREERTOS_MEMMANG_TYPE}")
endif()

# --------------------------------------
# Figure out the directories needed for a specific device
# --------------------------------------
set(FREERTOS_ROOT "${CMAKE_CURRENT_LIST_DIR}")
set(FREERTOS_GENERAL_INC_DIR "${FREERTOS_ROOT}/include")

# Set device specific paths for the STM32 Family
if(STM32_DEVICE_FAMILY)

    # STM32F4
    if("${STM32_DEVICE_FAMILY}" STREQUAL "F4")
        message(STATUS "FreeRTOS: Found supported STM32F4 family")
        set(FREERTOS_DEVICE_INC_DIR "${FREERTOS_ROOT}/portable/GCC/ARM_CM4F")
        set(FREERTOS_COMPILER_OPTIONS ${STM32_COMPILER_OPTIONS})

    # STM32F7
    elseif("${STM32_DEVICE_FAMILY}" STREQUAL "F7")
        message(STATUS "FreeRTOS: Found supported STM32F7 family")
        set(FREERTOS_DEVICE_INC_DIR "${FREERTOS_ROOT}/portable/GCC/ARM_CM7/r0p1")
        set(FREERTOS_COMPILER_OPTIONS ${STM32_COMPILER_OPTIONS})

    # UNKNOWN/UNSUPPORTED
    else()
        message(FATAL_ERROR "Device family ${STM32_DEVICE_FAMILY} isn't supported yet!")
    endif()

# Oops
else()
    message(FATAL_ERROR "Unknown device to compile FreeRTOS for!")  
endif()

# Create the combined header directory and make it public to whoever includes this file
set(FREERTOS_INC_DIRS "${FREERTOS_GENERAL_INC_DIR}" "${FREERTOS_DEVICE_INC_DIR}")
set_property(GLOBAL PROPERTY FREERTOS_INC_DIRS "${FREERTOS_INC_DIRS}")

# --------------------------------------
# Find the specific source files
# --------------------------------------
set(FREERTOS_DEVICE_SRC_FILES "${FREERTOS_DEVICE_INC_DIR}/port.c")
set(FREERTOS_COMMON_SRC_FILES "${FREERTOS_ROOT}/portable/Common/mpu_wrappers.c")
set(FREERTOS_MEMMANG_SRC_FILES "${FREERTOS_ROOT}/portable/MemMang/${FREERTOS_MEMMANG_NAME}.c")
set(FREERTOS_ROOT_SRC_FILES 
    "${FREERTOS_ROOT}/croutine.c"
    "${FREERTOS_ROOT}/event_groups.c"
    "${FREERTOS_ROOT}/list.c"
    "${FREERTOS_ROOT}/queue.c"
    "${FREERTOS_ROOT}/stream_buffer.c"
    "${FREERTOS_ROOT}/tasks.c"
    "${FREERTOS_ROOT}/timers.c"
)

set(FREERTOS_SRC_FILES
    "${FREERTOS_DEVICE_SRC_FILES}"
    "${FREERTOS_COMMON_SRC_FILES}"
    "${FREERTOS_MEMMANG_SRC_FILES}"
    "${FREERTOS_ROOT_SRC_FILES}"
)

# --------------------------------------
# Store all the header files 
# --------------------------------------



# --------------------------------------
# Define the project
# --------------------------------------
project(FreeRTOS VERSION 10.0.0)

if(CMAKE_GENERATOR STREQUAL "Unix Makefiles" OR CMAKE_GENERATOR STREQUAL "MinGW Makefiles")
    add_library(${PROJECT_NAME} STATIC ${FREERTOS_SRC_FILES})
endif()

# Add the include directories, making sure other projects can see them
target_include_directories(${PROJECT_NAME} PUBLIC ${FREERTOS_INC_DIRS})

# Add target/build specific compiler options
target_compile_options(${PROJECT_NAME} PRIVATE ${FREERTOS_COMPILER_OPTIONS} --std=gnu11)
target_compile_options(${PROJECT_NAME} PRIVATE $<$<CONFIG:DEBUG>:-ggdb -Og>)
target_compile_options(${PROJECT_NAME} PRIVATE $<$<CONFIG:RELEASE>:-O3>)

# Add target/build specific definitions, making sure other projects can see them
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<CONFIG:DEBUG>: -DDEBUG=1>)
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<CONFIG:RELEASE>: -DNDEBUG=1 -DRELEASE=1>)