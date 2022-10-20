//
//  DeviceSelectionViewController.h
//  RTKOTASDKDemo
//
//  Created by jerome_gu on 2021/11/18.
//  Copyright © 2021 Realtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceSelectionViewController : UITableViewController

@property NSArray <CBUUID *> *serviceUUIDs;

@property (copy) void(^selectionHandler)(id device);

@end

NS_ASSUME_NONNULL_END
