# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 3.12

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = "C:\Program Files\CMake\bin\cmake.exe"

# The command to remove a file.
RM = "C:\Program Files\CMake\bin\cmake.exe" -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = C:\git\Microcontrollers\Thor_STM32\Thor\lib\FreeRTOS

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = C:\git\Microcontrollers\Thor_STM32\Thor\lib\FreeRTOS\build

# Utility rule file for debug.

# Include the progress variables for this target.
include CMakeFiles/debug.dir/progress.make

CMakeFiles/debug:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=C:\git\Microcontrollers\Thor_STM32\Thor\lib\FreeRTOS\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Creating the executable in the debug mode."
	"C:\Program Files\CMake\bin\cmake.exe" -DCMAKE_BUILD_TYPE=Debug C:/git/Microcontrollers/Thor_STM32/Thor/lib/FreeRTOS
	"C:\Program Files\CMake\bin\cmake.exe" --build C:/git/Microcontrollers/Thor_STM32/Thor/lib/FreeRTOS/build --target all

debug: CMakeFiles/debug
debug: CMakeFiles/debug.dir/build.make

.PHONY : debug

# Rule to build all files generated by this target.
CMakeFiles/debug.dir/build: debug

.PHONY : CMakeFiles/debug.dir/build

CMakeFiles/debug.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles\debug.dir\cmake_clean.cmake
.PHONY : CMakeFiles/debug.dir/clean

CMakeFiles/debug.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" C:\git\Microcontrollers\Thor_STM32\Thor\lib\FreeRTOS C:\git\Microcontrollers\Thor_STM32\Thor\lib\FreeRTOS C:\git\Microcontrollers\Thor_STM32\Thor\lib\FreeRTOS\build C:\git\Microcontrollers\Thor_STM32\Thor\lib\FreeRTOS\build C:\git\Microcontrollers\Thor_STM32\Thor\lib\FreeRTOS\build\CMakeFiles\debug.dir\DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/debug.dir/depend

