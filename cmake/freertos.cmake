

# This is so we can find any needed packages
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${INSTALL_CMAKE_ROOT_DIR})

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

            message(STATUS "FreeRTOS: Found supported STM32F4 family")

        # STM32F7
        elseif("${FAMILY}" STREQUAL "F7")
            include("${ROOT_DIR}/cmake/stm32-cmake/cmake/gcc_stm32f7.cmake")
            
            set(${REL_DEVICE_INC_DIRS} "portable/GCC/ARM_CM7/r0p1")
            set(${COMPILER_OPTIONS} "${STM32F7_COMPILER_OPTIONS}")

            message(STATUS "FreeRTOS: Found supported STM32F7 family")

        # UNKNOWN/UNSUPPORTED
        else()
            message(FATAL_ERROR "Developer hasn't added support for this family despite it being listed. Bad developer! Bad!")
        endif()
    else()
        message(FATAL_ERROR "Device family ${FAMILY} isn't supported yet!")
    endif()
endmacro()

# --------------------------------------
# Get the module installation root directory
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
