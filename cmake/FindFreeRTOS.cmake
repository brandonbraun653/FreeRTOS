# --------------------------------------
# Global variables
# --------------------------------------
# The directory where this FindFreeRTOS.cmake file should lie. All paths are based on this.
file(TO_CMAKE_PATH "$ENV{CMAKE_MODULES}" MODULE_ROOT_DIR)

# Expected foldername for all FreeRTOS builds, variants, etc.
set(FREERTOS_REL_ROOT_FOLDER "freertos")
set(FREERTOS_ABS_ROOT_FOLDER "${MODULE_ROOT_DIR}/${FREERTOS_REL_ROOT_FOLDER}")

# Variables the user will/might have passed in
set(PACKAGE_NAME "${CMAKE_FIND_PACKAGE_NAME}")
set(PACKAGE_REQUIRED "${${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED}")
set(PACKAGE_VERSION "${${CMAKE_FIND_PACKAGE_NAME}_FIND_VERSION}")
set(PACKAGE_VERSION_EXACT "${${CMAKE_FIND_PACKAGE_NAME}_FIND_VERSION_EXACT}")
set(PACKAGE_COMPONENTS "${${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS}")

# --------------------------------------
# Definitions for various functions needed to find things 
# --------------------------------------
function(CHECK_PACKAGE_NAME PACKAGE_NAME)
    string(TOUPPER "${PACKAGE_NAME}" SANITIZED_PACKAGE_NAME)
    string(STRIP "${SANITIZED_PACKAGE_NAME}" SANITIZED_PACKAGE_NAME)

    if(NOT "${SANITIZED_PACKAGE_NAME}" STREQUAL "FREERTOS")
        message(FATAL_ERROR "Invalid package name [${PACKAGE_NAME}]. Expected some variant of FreeRTOS.")
    endif()
endfunction()


# --------------------------------------
# Checks if a folder with the given version string has been installed 
#
# @param[in]    VERSION     Version string from <package_name>_FIND_VERSION
# @param[in]    EXACT       User param of whether the version string needs to be exact
# @param[out]   REL_PATH    Relative path to the found version from the root dir
# @param[out]   FOUND       Set to "1" if found, "0" if not.
# --------------------------------------
function(FIND_FREERTOS_VERSION VERSION EXACT REL_PATH ACTUAL_VERSION)
    # --------------------------------------
    # Get a list of all directories/files in the expected FreeRTOS root folder
    # --------------------------------------
    file(GLOB CANDIDATE_VERSION_DIR_LIST 
         LIST_DIRECTORIES true
         RELATIVE "${FREERTOS_ABS_ROOT_FOLDER}" "${FREERTOS_ABS_ROOT_FOLDER}/*")

    # --------------------------------------
    # Check each result for if it is a directory
    # --------------------------------------
    set(VERSION_DIR_LIST "")
    foreach(candidate ${CANDIDATE_VERSION_DIR_LIST})
        if(IS_DIRECTORY "${FREERTOS_ABS_ROOT_FOLDER}/${candidate}")
            list(APPEND VERSION_DIR_LIST ${candidate})
        endif()
    endforeach()

    # --------------------------------------
    # Assuming a valid version directory exists, set the appropriate variables
    # --------------------------------------
    if("${VERSION}" IN_LIST VERSION_DIR_LIST)
        set(${REL_PATH} "${FREERTOS_REL_ROOT_FOLDER}/${VERSION}" PARENT_SCOPE)
        set(${ACTUAL_VERSION} ${VERSION} PARENT_SCOPE)
    else()
        # If exact is specified, immediately fail cause we couldn't find it
        if("${EXACT}" STREQUAL "1")
            set(${REL_PATH} "" PARENT_SCOPE)
            message(FATAL_ERROR "FreeRTOS: Could not find version that exactly matched ${VERSION}")

        # Otherwise, if we have ANY version, assume it works. Choose the first one.
        elseif(VERSION_DIR_LIST)
            list(GET VERSION_DIR_LIST 0 FIRST_DIR)
            set(${REL_PATH} "${FREERTOS_REL_ROOT_FOLDER}/${FIRST_DIR}" PARENT_SCOPE)
            set(${ACTUAL_VERSION} ${FIRST_DIR} PARENT_SCOPE)
        else()
            message(FATAL_ERROR "FreeRTOS: Could not find any installed versions")
        endif()
    endif()
endfunction()

# --------------------------------------
# Checks inside a given version directory for the specified components
#
# @param[in]    COMPONENTS           The expected targets FreeRTOS was compiled for
# @param[in]    REL_VERSION_PATH     Relative path to a FreeRTOS install version
# @param[out]   REL_COMPONENT_PATHS  Relative paths to the found component target
# --------------------------------------
function(FIND_FREERTOS_COMPONENTS COMPONENTS ABS_VERSION_PATH ABS_COMPONENT_PATHS)
    # --------------------------------------
    # Get a list of all directories/files in the expected folder
    # --------------------------------------
    file(GLOB CANDIDATE_DIR_LIST LIST_DIRECTORIES true "${ABS_VERSION_PATH}/*")

    # --------------------------------------
    # Check each result for if it is a directory
    # --------------------------------------
    set(VALID_COMPONENT_PATHS "")

    #message(STATUS "Dir list: [${CANDIDATE_DIR_LIST}]")

    foreach(CANDIDATE_DIR ${CANDIDATE_DIR_LIST})
        if(IS_DIRECTORY "${CANDIDATE_DIR}")
            string(TOLOWER "${CANDIDATE_DIR}" CANDIDATE_DIR_LOWER)
            
            foreach(component ${COMPONENTS})
                set(ABS_PATH "${ABS_VERSION_PATH}/${component}")
                string(TOLOWER "${ABS_PATH}" ABS_PATH_LOWER)

                if("${ABS_PATH_LOWER}" STREQUAL "${CANDIDATE_DIR_LOWER}")
                    list(APPEND VALID_COMPONENT_PATHS "${CANDIDATE_DIR_LOWER}")
                endif()

            endforeach()
        else()
            message(STATUS "NOT A DIR! [${CANDIDATE_DIR}]")
        endif()
    endforeach()

    set(${ABS_COMPONENT_PATHS} ${VALID_COMPONENT_PATHS} PARENT_SCOPE)
endfunction()

function(GLOB_FILENAMES DIR EXPR LIST_RESULT)
    file(GLOB FOUND_FILES "${DIR}/${EXPR}")

    set(FOUND_FILE_NAMES "")
    foreach(FILE ${FOUND_FILES})
        get_filename_component(filename "${FILE}" NAME)
        list(APPEND FOUND_FILE_NAMES ${filename})
    endforeach()

    set(${LIST_RESULT} ${FOUND_FILE_NAMES} PARENT_SCOPE)

endfunction()

# --------------------------------------
# Includes all the found components so that the user has access to target definitions
#
# @param[in]   REL_COMPONENT_PATHS  Relative paths to the found component target
# --------------------------------------
macro(IMPORT_FREERTOS_COMPONENTS ABS_COMPONENT_PATHS)

    # Search through all the component paths for valid Find<>.cmake files
    foreach(cpath ${ABS_COMPONENT_PATHS})

        # Grab the .cmake files that begin with "Find" and don't have a hyphen
        # Hyphenated files are usually included by the "Find<>.cmake" files.
        GLOB_FILENAMES(${cpath} "*.cmake" VALID_CMAKE_FILES)
        list(FILTER VALID_CMAKE_FILES EXCLUDE REGEX "-")
        list(FILTER VALID_CMAKE_FILES INCLUDE REGEX "^Find")

        # Include each found file
        foreach(file ${VALID_CMAKE_FILES})
            include("${cpath}/${file}")
        endforeach()

    endforeach()

endmacro()

# ------------------------------------------------------------------
# The actual finding operation happens below
# ------------------------------------------------------------------
CHECK_PACKAGE_NAME(${CMAKE_FIND_PACKAGE_NAME})

FIND_FREERTOS_VERSION(${PACKAGE_VERSION} ${PACKAGE_VERSION_EXACT} REL_VERSION_PATH FOUND_VERSION)

set(ABS_VERSION_PATH "${MODULE_ROOT_DIR}/${REL_VERSION_PATH}")

FIND_FREERTOS_COMPONENTS(${PACKAGE_COMPONENTS} ${ABS_VERSION_PATH} ABS_COMPONENT_PATHS)

IMPORT_FREERTOS_COMPONENTS(${ABS_COMPONENT_PATHS})

# ------------------------------------------------------------------
# If we make it this far, consider it a success 
# ------------------------------------------------------------------
message(STATUS "FreeRTOS Version: ${FOUND_VERSION}")