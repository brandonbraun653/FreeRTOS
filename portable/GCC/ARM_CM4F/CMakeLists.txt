include(CTEmbedded)

gen_static_lib_variants(
  TARGET
    freertos_cm4f_port
  SOURCES
    arm_cm4f_port.c
  PUB_DEFINES
    FREERTOS_CFG_PORT_ARM_CM4F=1
  PUB_INCLUDES
    ./
  PRV_LIBRARIES
    freertos_intf_inc_all
  EXPORT_DIR
    "${PROJECT_BINARY_DIR}/FreeRTOS"
)
