include(CTEmbedded)

gen_static_lib_variants(
  TARGET
    freertos_posix_port
  SOURCES
    posix_port.c
    utils/wait_for_event.c
  PUB_DEFINES
    FREERTOS_CFG_PORT_POSIX=1
  PUB_INCLUDES
    ./
  PRV_LIBRARIES
    freertos_intf_inc_all
  EXPORT_DIR
    "${PROJECT_BINARY_DIR}/FreeRTOS"
)
