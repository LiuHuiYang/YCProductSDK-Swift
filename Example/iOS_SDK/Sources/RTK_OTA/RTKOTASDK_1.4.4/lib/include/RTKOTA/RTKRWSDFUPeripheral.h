//
//  RTKRWSDFUPeripheral.h
//  RTKOTASDK
//
//  Created by jerome_gu on 2019/11/19.
//  Copyright © 2022 Realtek. All rights reserved.
//

#import "RTKMultiDFUPeripheral.h"

NS_ASSUME_NONNULL_BEGIN

@class RTKRWSDFUPeripheral;
@protocol RTKRWSDFUPeripheralDelegate <RTKMultiDFUPeripheralDelegate>
@optional
- (void)DFUPeripheral:(RTKMultiDFUPeripheral *)peripheral did:(RTKOTAUpgradeBin *)image;

@end


@interface RTKRWSDFUPeripheral : RTKMultiDFUPeripheral

@property (nonatomic, weak) id <RTKRWSDFUPeripheralDelegate> delegate;

- (void)upgradeImages:(NSArray <RTKOTAUpgradeBin*> *)images secondaryImages:(NSArray <RTKOTAUpgradeBin*> *)secondaryImages;

@end

NS_ASSUME_NONNULL_END
