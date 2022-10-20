//
//  libRTKLEFoundation.h
//  libRTKLEFoundation
//
//  Created by jerome_gu on 2021/2/2.
//  Copyright © 2022 Realtek. All rights reserved.
//

#ifndef libRTKLEFoundation_h
#define libRTKLEFoundation_h

// This header is used for static library build.
// Note: When link with the static library, code should import this header only, rather than import individual headers which is included by this header.

#ifndef RTK_SDK_IS_STATIC_LIBRARY
#define RTK_SDK_IS_STATIC_LIBRARY
#endif


#import "RTKBTGeneralDefines.h"

#import "RTKProfileConnectionManager.h"
#import "RTKProfileConnection.h"
#import "RTKConnectionUponGATT.h"
#import "RTKConnectionUponiAP.h"
#import "RTKOperationWaitor.h"
#import "RTKCharacteristicOperate.h"
#import "RTKCharacteristicTRXTransport.h"

#import "RTKPacket.h"
#import "RTKPacketTransport.h"

#import "RTKActionAttempt.h"

#import "RTKPackageIDGenerator.h"
#import "RTKBTLogMacros.h"
#import "RTKError.h"

#import "RTKAccessorySessionTransport.h"

#import "RTKBatchDataSendReception.h"


/* Utilities */

#import "NSData+KKAES.h"
#import "NSData+CRC16.h"
#import "NSData+String.h"
#import "NSData+Generation.h"

#import "RTKProvisioningProfileExpirationCheck.h"

// Legacy APIs,
// deprecated, not recommended for new usage
#import "RTKLEPeripheral.h"
#import "RTKLEProfile.h"

#import "RTKPeripheralCharacteristicOperation.h"
#import "RTKLEPackage.h"
#import "RTKPackageCommunication.h"
#import "RTKCharacteristicReadWrite.h"
#import "RTKCommunicationDataReceiver.h"
#import "RTKCommunicationDataSender.h"

#import "RTKAttemptAction.h"

#import "RTKPackageIDGenerator.h"

#import "RTKAccessoryManager.h"
#import "RTKAccessory.h"


#endif
