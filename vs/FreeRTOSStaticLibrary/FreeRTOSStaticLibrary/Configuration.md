## Configuration Setup
-----------------------
This solution is intended to be included as part of a larger project, primarily to cut down on how much effort is required 
to configure and compile Chimera. 


A few configuration settings for include paths and compiler defines are set by a global property sheet. If you open the 
Property Manager, you will see there is a sheet called "CommonProperties" that is shared across all configurations. One of 
these properties imports another property sheet called "ProjectWideConfiguration", whose location is defined at the top 
level solution directory. It is important to note that expansion of the `$(SolutionDir)` macro equals the Startup Project 
solution directory. 

To view the currently configured macros, follow the 
[Microsoft documentation](https://docs.microsoft.com/en-us/cpp/build/reference/common-macros-for-build-commands-and-properties?view=vs-2019).

### Configuration XML Block
---------------------------
File: *CommonProperties.props*
```xml
<ImportGroup Label="PropertySheets">
  <Import Project="$(SolutionDir)ProjectWideConfiguration.props" />
</ImportGroup>
```

## How to Add Configuration Parameters
---------------------------------------
https://sites.google.com/site/pinyotae/Home/visual-studio-visual-c/create-user-defined-environment-variables-macros  
https://docs.microsoft.com/en-us/cpp/build/create-reusable-property-configurations?view=vs-2019  
https://stackoverflow.com/questions/4710084/visual-studio-where-to-define-custom-path-macros

### Required Configuration Parameters
-------------------------------------
| Parameter                    | Explanation                                            |
|------------------------------|--------------------------------------------------------|
| `$(FreeRTOSPortDir)`         | Directory that contains "portmacro.h" & "port.c"       |
| `$(FreeRTOSCfgDir)`          | Directory that contains "FreeRTOSConfig.hpp"           |
| `$(FreeRTOSCompilerDefines)` | Compiler definitions needed to configure the code base |

### Required Compiler Definitions
-------------------------------------
#### Port Configuration (Choose One)
| Supported Definition           | Explanation                                         |
|--------------------------------|-----------------------------------------------------|
| FREERTOS_CFG_PORT_MSVC         | Enables support for MSVC compilation                |
| FREERTOS_CFG_PORT_POSIX        | Enables support for Posix compilation               |
| FREERTOS_CFG_PORT_ARM_CM4F     | Enables support for ARM CM4F variant processors     |
| FREERTOS_CFG_PORT_ARM_CM7_R0P1 | Enables support for ARM CM7 R0P1 variant processors |

#### Memory Management (Choose One)
| Supported Definition        | Explanation                                              |
|-----------------------------|----------------------------------------------------------|
| FREERTOS_CFG_MEM_MANG_HEAP1 | Enables compiling of heap_1.c memory management strategy |
| FREERTOS_CFG_MEM_MANG_HEAP2 | Enables compiling of heap_2.c memory management strategy |
| FREERTOS_CFG_MEM_MANG_HEAP3 | Enables compiling of heap_3.c memory management strategy |
| FREERTOS_CFG_MEM_MANG_HEAP4 | Enables compiling of heap_4.c memory management strategy |
| FREERTOS_CFG_MEM_MANG_HEAP5 | Enables compiling of heap_5.c memory management strategy |