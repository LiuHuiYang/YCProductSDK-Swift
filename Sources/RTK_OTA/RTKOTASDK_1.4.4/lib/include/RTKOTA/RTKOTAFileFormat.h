
//
//  RTKOTAFileFormat.h
//  RTKLEFoundation
//
//  Created by jerome_gu on 2019/1/28.
//  Copyright © 2022 Realtek. All rights reserved.
//

#ifndef RTKOTAFileFormat_h
#define RTKOTAFileFormat_h

typedef NS_ENUM(uint16_t, RTKSubBinHeaderType)
{
    RTKSubBinHeaderType_BinID           = 0x0001,
    RTKSubBinHeaderType_Version         = 0x0002,
    RTKSubBinHeaderType_PartNumber      = 0x0003,
    RTKSubBinHeaderType_Length          = 0x0004,
    
    RTKSubBinHeaderType_OTAVersion      = 0x0011,
    RTKSubBinHeaderType_ImageID         = 0x0012,
    RTKSubBinHeaderType_FlashAddr       = 0x0013,
    RTKSubBinHeaderType_ImageSize       = 0x0014,
    RTKSubBinHeaderType_SecVersion      = 0x0015,
    RTKSubBinHeaderType_ImageVersion    = 0x0016,
    RTKSubBinHeaderType_SHA256Offset    = 0x001B,
    RTKSubBinHeaderType_PubKeyHash      = 0x001D,
    RTKSubBinHeaderType_ICType          = 0x0100,   //Bee3Pro
};


typedef NS_ENUM(uint16_t, RTKOTABinId)
{
    RTKOTABinId_SystemConfig        =   0x0100,
    RTKOTABinId_SOCV_CFG            =   0x0101,
    RTKOTABinId_RomPatch            =   0x0200,
    RTKOTABinId_PlatformImg         =   0x0201,
    RTKOTABinId_LowerStackImg       =   0x0202,
    RTKOTABinId_UpperStackImg       =   0x0203,
    RTKOTABinId_FrameworkImg        =   0x0204,
    RTKOTABinId_PreSysPatchImg      =   0x0205,
    RTKOTABinId_PreStackPatchImg    =   0x0206,
    RTKOTABinId_PreUpperStackImg    =   0x0207,
    RTKOTABinId_VoicePromptData     =   0x0208,
    
    RTKOTABinId_AppImg              =   0x0300,
    RTKOTABinId_AppUIParameter      =   0x0400,
    RTKOTABinId_DSPUIParameter      =   0x0410,
    RTKOTABinId_DSPSystem           =   0x0500,
    RTKOTABinId_DSPApp              =   0x0602,
    
    RTKOTABinId_SecureBootLoader    =   0x0700,
    RTKOTABinId_OTAHeader           =   0x0800,
    
    RTKOTABinId_ExtImage0           =   0x0900,
    RTKOTABinId_ExtImage1           =   0x0901,
    RTKOTABinId_ExtImage2           =   0x0902,
    RTKOTABinId_ExtImage3           =   0x0903,
    
    RTKOTABinId_AppData1            =   0x0901,
    RTKOTABinId_AppData2            =   0x0902,
    RTKOTABinId_AppData3            =   0x0903,
    RTKOTABinId_AppData4            =   0x0904,
    RTKOTABinId_AppData5            =   0x0905,
    RTKOTABinId_AppData6            =   0x0906,
    RTKOTABinId_AppData7            =   0x0907,
    RTKOTABinId_AppData8            =   0x0908,
    RTKOTABinId_AppData9            =   0x0909,
    RTKOTABinId_AppData10           =   0x090A,
    
    RTKOTABinId_FactoryImage        =   0x0a00,
    
    RTKOTABinId_BackupData1         =   0x0b00,
    RTKOTABinId_BackupData2         =   0x0b01,
    
    RTKOTABinId_UserData1           =   0xF001,
    RTKOTABinId_UserData2           =   0xF002,
    RTKOTABinId_UserData3           =   0xF003,
    RTKOTABinId_UserData4           =   0xF004,
    RTKOTABinId_UserData5           =   0xF005,
    RTKOTABinId_UserData6           =   0xF006,
    RTKOTABinId_UserData7           =   0xF007,
    RTKOTABinId_UserData8           =   0xF008,
    
    //Bee3Pro
    RTKOTABinId_SecurePatchImage       =   0x0700,
    RTKOTABinId_SecureAPPImage         =   0x0301,
    RTKOTABinId_SecureAPPData          =   0x0411,
    RTKOTABinId_PMCPatchImage          =   0x0202,
    RTKOTABinId_BTSystemPatchImage     =   0x0204,
    RTKOTABinId_BTLowerStackPatchImage =   0x0203,
    RTKOTABinId_NonSecurePatchImage    =   0x0200,
    RTKOTABinId_UpperStackImage        =   0x0a00,
};


#pragma pack(push, 1)

typedef struct {
    RTKSubBinHeaderType    type;
    uint8_t    length;
    void*       dataAt;
} RTKOTAMPSubBinHeader;

typedef struct {
    uint32_t    flashOffset;
    uint32_t    size;
    uint32_t    reserved;
} RTKOTAMPSubFileIndicator;

typedef struct {
    uint16_t    signature;
    uint32_t    size;
    uint8_t     checkSum[32];
    union {
        uint16_t value;
        struct {
            uint8_t packVersion : 4;
            uint8_t reserved : 3;
            uint8_t isDualBank : 1;
            uint8_t icType;
        } components;
    } extension;
    union {
        uint32_t    value;
        struct {
            uint16_t bank0;
            uint16_t bank1;
        } components;
    } indicator;
    RTKOTAMPSubFileIndicator subFileIndicator;
} RTKOTAMPPackHeader;

typedef struct {
    uint16_t    signature;
    uint32_t    size;
    uint8_t     checkSum[32];
    union {
        uint16_t value;
        struct {
            uint8_t packVersion : 4;
            uint8_t reserved : 2;
            uint8_t packForOTA: 1;
            uint8_t isDualBank : 1;
            uint8_t icType;
        } components;
    } extension;
    union {
        uint32_t    value[8];
        struct {
            uint64_t bank0[2];
            uint64_t bank1[2];
        } components;
    } indicator;
    RTKOTAMPSubFileIndicator subFileIndicator;
} RTKOTAMPPackHeaderNew;


typedef struct {
    uint8_t    ic_type;
    uint8_t    ota_flag;
    uint16_t   signature;
    uint16_t   version;
    uint16_t   crc16;
    uint32_t   length;
} RTKOTAImageHeader;

typedef struct {
    uint16_t    crc16;
    uint8_t    ic_type;
    uint8_t   secureVersion;
    uint16_t   ctrl_flag;
    uint16_t   imageID;
    uint32_t   imageLen;
} RTKOTABB2ImageHeader;


/* Image Version Format
 * [Image Version Format Reference](https://wiki.realtek.com/pages/viewpage.action?pageId=109786831)
 */

union VersionFormatNormal {
    uint32_t numberValue;
    struct {
        uint32_t major: 8;
        uint32_t minor: 8;
        uint32_t revision: 8;
        uint32_t build: 8;
    } component;
};

union VersionFormatBee2 {
    uint32_t numberValue;
    struct {
        uint32_t major: 4;
        uint32_t minor: 8;
        uint32_t revision: 15;
        uint32_t build: 5;
    } component;
};

union VersionFormatBBpro {
    uint32_t numberValue;
    struct {
        uint32_t build: 8;
        uint32_t revision: 8;
        uint32_t minor: 8;
        uint32_t major: 8;
    } component;
};

union VersionFormatBBproApp {
    uint32_t numberValue;
    struct {
        uint32_t major: 4;
        uint32_t minor: 8;
        uint32_t revision: 9;
        uint32_t build: 11;
    } component;
};

union VersionFormatBBproPatch {
    uint32_t numberValue;
    struct {
        uint32_t major: 4;
        uint32_t minor: 8;
        uint32_t revision: 15;
        uint32_t build: 5;
    } component;
};

union VersionFormatOTA {
    uint32_t numberValue;
    struct {
        uint32_t build: 8;
        uint32_t revision: 8;
        uint32_t minor: 8;
        uint32_t major: 8;
    } component;
};

union VersionFormatDSP {
    uint32_t numberValue;
    struct {
        uint8_t customer_info: 8;
        uint8_t svn_revision: 8;
        uint8_t svn_minor: 8;
        uint8_t svn_major: 8;
    } component;
};


union VersionFormatDSPConfig {
    uint32_t numberValue;
    struct {
        uint8_t minor: 8;
        uint8_t major: 8;
        uint8_t custom_minor: 8;
        uint8_t custom_major: 8;
    } component;
};

union VersionFormatDSPLegacy {
    uint32_t numberValue;
    struct {
        uint32_t rsv: 16;
        uint8_t minor: 8;
        uint8_t major: 8;
    } component;
};


#pragma pack(pop)

#endif /* RTKOTAFileFormat_h */
