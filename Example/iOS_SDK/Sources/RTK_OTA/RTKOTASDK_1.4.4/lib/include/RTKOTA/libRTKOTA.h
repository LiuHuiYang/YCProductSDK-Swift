//
//  libRTKOTA.h
//  RTKOTA
//
//  Created by jerome_gu on 2021/2/2.
//

#ifndef libRTKOTA_h
#define libRTKOTA_h

// This header is used for static library build.
// Note: When link with the static library, code should import this header only, rather than import individual headers which is contained.

#ifndef RTK_SDK_IS_STATIC_LIBRARY
#define RTK_SDK_IS_STATIC_LIBRARY
#endif

#import "RTKOTADeviceInfo.h"

#import "RTKOTABin.h"
#import "RTKOTAInstalledBin.h"
#import "RTKOTAUpgradeBin.h"
#import "RTKOTAUpgradeBin+Available.h"

#import "RTKOTAError.h"

#import "RTKDFUUpgrade.h"
#import "RTKDFURoutine.h"
#import "RTKDFUConnectionUponGATT.h"
#import "RTKDFUConnectionUponiAP.h"
#import "RTKDFUManager.h"

// Legacy APIs for compability, not recommended to be use.
#import "RTKOTAProfile.h"
#import "RTKOTAPeripheral.h"
#import "RTKDFUPeripheral.h"
#import "RTKMultiDFUPeripheral.h"

#endif /* libRTKOTA_h */
