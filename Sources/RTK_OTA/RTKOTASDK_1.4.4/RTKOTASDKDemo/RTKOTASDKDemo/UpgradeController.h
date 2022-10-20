//
//  UpgradeController.h
//  RTKOTASDKDemo
//
//  Created by irene_wang on 2021/4/7.
//  Copyright © 2021 Realtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTKOTASDK/RTKOTASDK.h>

@interface UpgradeController : UITableViewController
@property (nonatomic) RTKDFUUpgrade *upgradeTask;
@end
