# --------------------------------------
# Top level description of supported MCU families
# --------------------------------------
set(SUPPORTED_TARGET_ARCHITECTURES "STM32")
# add more later

# --------------------------------------
# For each MCU type, give specific supported architectures
# --------------------------------------
set(STM32_SUPPORTED_DEVICE_FAMILIES "F4" "F7")
# add more later


# --------------------------------------
# STM32 SERIES DEVICES:
# Get the toolchain, compiler options, and relative include directories. Left as a 
# macro so the toolchain gets imported into the parent workspace correctly.
# --------------------------------------
macro(FREERTOS_GET_STM32_PROPERTIES FAMILY ROOT_DIR REL_DEVICE_INC_DIRS REL_CFG_INC_DIR COMPILER_OPTIONS EXPORT_FOLDER)
    if(${FAMILY} IN_LIST STM32_SUPPORTED_DEVICE_FAMILIES)
        include("${${ROOT_DIR}}/cmake/stm32-cmake/cmake/toolchain.cmake")

        set(${REL_CFG_INC_DIR} "config/stm32")

        # STM32F4
        if(${FAMILY} STREQUAL "F4")
            include("${${ROOT_DIR}}/cmake/stm32-cmake/cmake/gcc_stm32f4.cmake")

            set(${REL_DEVICE_INC_DIRS} "portable/GCC/ARM_CM4F")
            set(${COMPILER_OPTIONS} "${STM32F4_COMPILER_OPTIONS}")
            set(${EXPORT_FOLDER} "STM32F4")

            message(STATUS "Found supported STM32F4 family")

        # STM32F7
        elseif("${FAMILY}" STREQUAL "F7")
            include("${ROOT_DIR}/cmake/stm32-cmake/cmake/gcc_stm32f7.cmake")
            
            set(${REL_DEVICE_INC_DIRS} "portable/GCC/ARM_CM7/r0p1")
            set(${COMPILER_OPTIONS} "${STM32F7_COMPILER_OPTIONS}")

            message(STATUS "Found supported STM32F7 family")

        # UNKNOWN/UNSUPPORTED
        else()
            message(FATAL_ERROR "Developer hasn't added support for this family despite it being listed. Bad developer! Bad!")
        endif()
    else()
        message(FATAL_ERROR "Device family ${FAMILY} isn't supported yet!")
    endif()
endmacro()

# --------------------------------------
# Process user defined target architectures/devices and import their properties
# --------------------------------------
macro(PROCESS_TARGET ARCHITECTURE DEVICE ROOT_DIR)
    if((NOT ${ARCHITECTURE}) OR (NOT ${ARCHITECTURE} IN_LIST SUPPORTED_TARGET_ARCHITECTURES))
        message(FATAL_ERROR "Please specify a valid TARGET_ARCHITECTURE to use for FreeRTOS. Options are [${SUPPORTED_TARGET_ARCHITECTURES}]")
    endif()

    # --------------------------------------
    # STM32 Architecture
    # --------------------------------------
    if(${ARCHITECTURE} STREQUAL "STM32")

        # Do we support the specified target?
        if((NOT ${DEVICE}) OR (NOT ${DEVICE} IN_LIST STM32_SUPPORTED_DEVICE_FAMILIES))
            message(FATAL_ERROR "Please specify a valid TARGET_DEVICE to use for architecture [${${ARCHITECTURE}}]. Options are [${STM32_SUPPORTED_DEVICE_FAMILIES}]")
        endif()

        FREERTOS_GET_STM32_PROPERTIES(
            ${DEVICE}
            ${ROOT_DIR}
            RELATIVE_TARGET_DEVICE_INC_DIR
            RELATIVE_CFG_INC_DIR
            TARGET_DEVICE_COMPILER_OPTIONS
            TARGET_DEVICE_EXPORT_SUBFLDR
        )
    else()
        message(FATAL_ERROR "Unknown target architecture [${ARCHITECTURE}]!")
    endif()
endmacro()

# --------------------------------------
# Get the global module installation root directory
# --------------------------------------
function(CMAKE_GET_MODULE_INSTALL_ROOT_DIR DIR)
    if($ENV{CMAKE_MODULES})
        set(CMAKE_MODULE_DIR $ENV{CMAKE_MODULES})
    else()
        if(WIN32)
            set(CMAKE_MODULE_DIR "C:/CMakeModules")
        elseif(UNIX)
            set(CMAKE_MODULE_DIR "/home/$ENV{USER}/CMakeModules")
        endif()
    endif()

    message(STATUS "Using CMake module install directory: ${CMAKE_MODULE_DIR}")

    set(${DIR} ${CMAKE_MODULE_DIR} PARENT_SCOPE)
endfunction()
