cmake_minimum_required(VERSION 3.12.2)
set(FREERTOS_VERSION "10.0.0")

# --------------------------------------
# Includes
# --------------------------------------
include("${CMAKE_CURRENT_LIST_DIR}/cmake/freertos.cmake")


# --------------------------------------
# Figure out the installation directories
# --------------------------------------
CMAKE_GET_MODULE_INSTALL_ROOT_DIR( INSTALL_ROOT_DIR )

set(FREERTOS_ROOT "${CMAKE_CURRENT_LIST_DIR}")
set(VERSION_INSTALL_DIR "${INSTALL_ROOT_DIR}/freertos/${FREERTOS_VERSION}")


# --------------------------------------
# Get properties for the given target architecture and device 
# --------------------------------------
if(TARGET_ARCHITECTURE)
    if(TARGET_DEVICE)
        if(${TARGET_ARCHITECTURE} STREQUAL "STM32")
            FREERTOS_GET_STM32_PROPERTIES(
                TARGET_DEVICE
                FREERTOS_ROOT
                FREERTOS_RELATIVE_DEVICE_INC_DIR
                FREERTOS_RELATIVE_CFG_INC_DIR
                FREERTOS_DEVICE_COMPILER_OPTIONS
                FREERTOS_DEVICE_EXPORT_SUBFLDR
            )
        else()
            message(FATAL_ERROR "Unknown target architecture [${TARGET_ARCHITECTURE}]!")
        endif()
    else()
        message(FATAL_ERROR "Please specify a TARGET_DEVICE to use for FreeRTOS architecture [${TARGET_ARCHITECTURE}]")
    endif()
else()
    message(FATAL_ERROR "Please specify a TARGET_ARCHITECTURE to use for FreeRTOS. Options are [${SUPPORTED_TARGET_ARCHITECTURES}]")
endif()


# Make sure we use a decent memory management strategy
if(NOT FREERTOS_MEMMANG_TYPE)
    set(FREERTOS_MEMMANG_FILENAME "heap_4")
else()
    set(FREERTOS_MEMMANG_FILENAME "heap_${FREERTOS_MEMMANG_TYPE}")
endif()

# --------------------------------------
# Directory names relative to FREERTOS_ROOT for finding files
# --------------------------------------
set(REL_COMMON_DIR "portable/Common")
set(REL_MEMMANG_DIR "portable/MemMang")
set(REL_INCLUDE_DIR "include")
set(REL_CMAKE_DIR "cmake")

# --------------------------------------
# Grab the needed .c files
# --------------------------------------
# Target architecture & device specific
set(FREERTOS_DEVICE_SRC_FILES 
    "${FREERTOS_ROOT}/${FREERTOS_RELATIVE_DEVICE_INC_DIR}/port.c"
)

set(FREERTOS_COMMON_SRC_FILES 
    "${FREERTOS_ROOT}/${REL_COMMON_DIR}/mpu_wrappers.c"
)

set(FREERTOS_MEMMANG_SRC_FILES 
    "${FREERTOS_ROOT}/${REL_MEMMANG_DIR}/${FREERTOS_MEMMANG_FILENAME}.c"
)

set(FREERTOS_ROOT_SRC_FILES 
    "${FREERTOS_ROOT}/croutine.c"
    "${FREERTOS_ROOT}/event_groups.c"
    "${FREERTOS_ROOT}/list.c"
    "${FREERTOS_ROOT}/queue.c"
    "${FREERTOS_ROOT}/stream_buffer.c"
    "${FREERTOS_ROOT}/tasks.c"
    "${FREERTOS_ROOT}/timers.c"
)

set(FREERTOS_ALL_SRC_FILES
    "${FREERTOS_DEVICE_SRC_FILES}"
    "${FREERTOS_COMMON_SRC_FILES}"
    "${FREERTOS_MEMMANG_SRC_FILES}"
    "${FREERTOS_ROOT_SRC_FILES}"
)

# --------------------------------------
# Grab all the needed .h files. This is for the purpose of installing all the 
# targets into the INSTALL_CMAKE_DIR and need to be relative paths.
# --------------------------------------
set(FREERTOS_DEVICE_INC_FILES
    "${FREERTOS_RELATIVE_DEVICE_INC_DIR}/portmacro.h"
)

set(FREERTOS_CFG_INC_FILES
    "${FREERTOS_RELATIVE_CFG_INC_DIR}/FreeRTOSConfig.h"
)

set(FREERTOS_GENERAL_INC_FILES
    "${REL_INCLUDE_DIR}/croutine.h"
    "${REL_INCLUDE_DIR}/deprecated_definitions.h"
    "${REL_INCLUDE_DIR}/event_groups.h"
    "${REL_INCLUDE_DIR}/FreeRTOS.h"
    "${REL_INCLUDE_DIR}/list.h"
    "${REL_INCLUDE_DIR}/message_buffer.h"
    "${REL_INCLUDE_DIR}/mpu_prototypes.h"
    "${REL_INCLUDE_DIR}/mpu_wrappers.h"
    "${REL_INCLUDE_DIR}/portable.h"
    "${REL_INCLUDE_DIR}/projdefs.h"
    "${REL_INCLUDE_DIR}/queue.h"
    "${REL_INCLUDE_DIR}/semphr.h"
    "${REL_INCLUDE_DIR}/StackMacros.h"
    "${REL_INCLUDE_DIR}/stack_macros.h"
    "${REL_INCLUDE_DIR}/stream_buffer.h"
    "${REL_INCLUDE_DIR}/task.h"
    "${REL_INCLUDE_DIR}/timers.h"
)

# --------------------------------------
# Set the include directories for both install and build
# --------------------------------------
# This is for local builds
set(FREERTOS_BUILD_INC_DIRS 
    "${FREERTOS_ROOT}/${FREERTOS_RELATIVE_CFG_INC_DIR}"
    "${FREERTOS_ROOT}/${FREERTOS_RELATIVE_DEVICE_INC_DIR}"
    "${FREERTOS_ROOT}/${REL_INCLUDE_DIR}"
)

# These are for the install command
set(FREERTOS_INSTALL_INC_DIRS
    "${INSTALL_CMAKE_DIR}/${FREERTOS_RELATIVE_CFG_INC_DIR}"
    "${INSTALL_CMAKE_DIR}/${FREERTOS_RELATIVE_DEVICE_INC_DIR}"
    "${INSTALL_CMAKE_DIR}/${REL_INCLUDE_DIR}"
)

# --------------------------------------
# Define the project
# --------------------------------------
project(FreeRTOS VERSION 10.0.0 LANGUAGES C)
add_library(${PROJECT_NAME} STATIC ${FREERTOS_ALL_SRC_FILES})

# Add the include directories
target_include_directories(${PROJECT_NAME} PRIVATE ${FREERTOS_BUILD_INC_DIRS})
target_include_directories(${PROJECT_NAME} INTERFACE
    "$<BUILD_INTERFACE:${FREERTOS_BUILD_INC_DIRS}>"
    "$<INSTALL_INTERFACE:${FREERTOS_INSTALL_INC_DIRS}>"
)

# Add target/build specific compiler options. Keep these private as usually FreeRTOS
# is a part of a larger project and has its own options we don't want to override.
target_compile_options(${PROJECT_NAME} PRIVATE ${FREERTOS_DEVICE_COMPILER_OPTIONS})
target_compile_options(${PROJECT_NAME} PRIVATE --std=gnu11)
target_compile_options(${PROJECT_NAME} PRIVATE $<$<CONFIG:DEBUG>:-ggdb -Og>)
target_compile_options(${PROJECT_NAME} PRIVATE $<$<CONFIG:RELEASE>:-O3>)

install(TARGETS ${PROJECT_NAME} EXPORT FindFreeRTOS
                DESTINATION "${VERSION_INSTALL_DIR}/${FREERTOS_DEVICE_EXPORT_SUBFLDR}" 
                INCLUDES DESTINATION "${FREERTOS_INSTALL_INC_DIRS}")

install(EXPORT FindFreeRTOS DESTINATION "${VERSION_INSTALL_DIR}/${FREERTOS_DEVICE_EXPORT_SUBFLDR}")

# Install the header files for use with find_package()
install(FILES ${FREERTOS_CFG_INC_FILES} DESTINATION ${VERSION_INSTALL_DIR}/${FREERTOS_RELATIVE_CFG_INC_DIR})
install(FILES ${FREERTOS_DEVICE_INC_FILES} DESTINATION ${VERSION_INSTALL_DIR}/${FREERTOS_RELATIVE_DEVICE_INC_DIR})
install(FILES ${FREERTOS_GENERAL_INC_FILES} DESTINATION ${VERSION_INSTALL_DIR}/${REL_INCLUDE_DIR})

# Install the FindFreeRTOS.cmake file
install(FILES ${REL_CMAKE_DIR}/FindFreeRTOS.cmake DESTINATION ${INSTALL_ROOT_DIR})