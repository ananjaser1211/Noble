#ifndef FIMC_IS_VENDOR_CONFIG_NOBLE_H
#define FIMC_IS_VENDOR_CONFIG_NOBLE_H

#include "fimc-is-from-rear-c2-imx240_v003.h"
#include "fimc-is-eeprom-front-5e3_v001.h"

#define CAMERA_SYSFS_V2
#define CAMERA_MODULE_DUALIZE
#define CAMERA_MODULE_AVAILABLE_DUMP_VERSION "B16"

#ifdef CONFIG_COMPANION_STANDBY_USE
#define CAMERA_PARALLEL_RETENTION_SEQUENCE
#define CONFIG_COMPANION_STANDBY_CRC
#define CONFIG_COMPANION_AUTOMATIC_CRC_ON_CLOSE
#endif

#define CAMERA_MODULE_CORE_CS_VERSION 'B'
#define CAMERA_OIS_DOM_UPDATE_VERSION 'I'
#define CAMERA_OIS_SEC_UPDATE_VERSION 'J'
#define CAMERA_MODULE_ES_VERSION_REAR 'B'
#define CAMERA_MODULE_ES_VERSION_FRONT 'A'
#define CAL_MAP_ES_VERSION_REAR '3'
#define CAL_MAP_ES_VERSION_FRONT '1'

#if defined(CONFIG_ARM_EXYNOS7420_BUS_DEVFREQ_TDNR)
/* Sync with SUPPORT_GROUP_MIGRATION in HAL Side. */
#define CONFIG_SUPPORT_GROUP_MIGRATION_FOR_TDNR
#define CONFIG_ENABLE_TDNR
#endif

#define CONFIG_FRONT_COMPANION_C2_DISABLE

#endif /* FIMC_IS_VENDOR_CONFIG_NOBLE_H */
