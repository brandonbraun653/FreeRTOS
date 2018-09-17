cmake_minimum_required(VERSION 3.12.2)
include("../../../cmake/gcc_stm32.cmake")

# Assign the Thor toolchain file if one isn't passed to the command line
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "../../../cmake/toolchain.cmake")
endif()

# Make sure we use a decent memory management strategy
if(NOT FREERTOS_MEMMANG_TYPE)
    set(FREERTOS_MEMMANG_NAME "heap_4")
else()
    set(FREERTOS_MEMMANG_NAME "heap_${FREERTOS_MEMMANG_TYPE}")
endif()

# Figure out the directories needed
set(FREERTOS_ROOT "${CMAKE_CURRENT_LIST_DIR}")

set(FREERTOS_GENERAL_INC_DIR "${FREERTOS_ROOT}/Include")

## Set device specific paths for the STM32 Family
message(STATUS "STM32Fam val: ${STM32_FAMILY}")
if(STM32_FAMILY)
    if("${STM32_FAMILY}" STREQUAL "F4")
        set(FREERTOS_DEVICE_INC_DIR "${FREERTOS_ROOT}/portable/GCC/ARM_CM4F")
        set(FREERTOS_COMPILE_OPTIONS ${STM32F4_COMPILE_OPTIONS})

    elseif("${STM32_FAMILY}" STREQUAL "F7")
        set(FREERTOS_DEVICE_INC_DIR "${FREERTOS_ROOT}/portable/GCC/ARM_CM7/r0p1")
        set(FREERTOS_COMPILE_OPTIONS ${STM32F7_COMPILE_OPTIONS})
        # TODO: There are a few other types of f7 dirs that might be there....
    else()
        message(FATAL_ERROR "Device family ${STM32_FAMILY} isn't supported yet!")
    endif()

else()
    message(FATAL_ERROR "Unknown device to compile FreeRTOS for!")  
endif()

## Find the relative source files
set(FREERTOS_DEVICE_SRC_FILES "${FREERTOS_DEVICE_INC_DIR}/port.c")
set(FREERTOS_COMMON_SRC_FILES "${FREERTOS_ROOT}/portable/Common/mpu_wrappers.c")
set(FREERTOS_MEMMANG_SRC_FILES "${FREERTOS_ROOT}/portable/Memmang/${FREERTOS_MEMMANG_NAME}.c")
file(GLOB FREERTOS_ROOT_SRC_FILES "${FREERTOS_ROOT}/*.c")

## Combine the source file listing and header directories into one set of vars
set(FREERTOS_INC_DIRS
    "${FREERTOS_GENERAL_INC_DIR}"
    "${FREERTOS_DEVICE_INC_DIR}"
)

set(FREERTOS_SRC_FILES
    "${FREERTOS_DEVICE_SRC_FILES}"
    "${FREERTOS_COMMON_SRC_FILES}"
    "${FREERTOS_MEMMANG_SRC_FILES}"
    "${FREERTOS_ROOT_SRC_FILES}"
)

## Now let's actually build this thing...
project(FreeRTOS)

if(CMAKE_GENERATOR STREQUAL "Unix Makefiles" OR CMAKE_GENERATOR STREQUAL "MinGW Makefiles")
    add_library(${PROJECT_NAME} STATIC ${FREERTOS_SRC_FILES})
endif()

# Add the include directories, making sure other projects can see them
target_include_directories(${PROJECT_NAME} PUBLIC ${FREERTOS_INC_DIRS})

# Add target/build specific compiler options
target_compile_options(${PROJECT_NAME} PRIVATE ${FREERTOS_COMPILE_OPTIONS})
target_compile_options(${PROJECT_NAME} PRIVATE $<$<CONFIG:DEBUG>:-ggdb -Og>)
target_compile_options(${PROJECT_NAME} PRIVATE $<$<CONFIG:RELEASE>:-O3>)

# Add target/build specific definitions, making sure other projects can see them
target_compile_definitions(${PROJECT_NAME} PUBLIC $<$<CONFIG:DEBUG>: -DDEBUG=1>)
target_compile_definitions(${PROJECT_NAME} PUBLIC $<$<CONFIG:RELEASE>: -DNDEBUG=1 -DRELEASE=1>)