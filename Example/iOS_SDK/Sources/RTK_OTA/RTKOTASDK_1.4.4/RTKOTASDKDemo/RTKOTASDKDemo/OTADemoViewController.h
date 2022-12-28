//
//  OTADemoViewController.h
//  RTKOTASDKDemo
//
//  Created by irene_wang on 2021/4/2.
//  Copyright © 2021 Realtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTKOTASDK/RTKOTASDK.h>
#import <RTKLEFoundation/RTKLEFoundation.h>

@interface OTADemoViewController : UITableViewController
@property (nonatomic) RTKDFUUpgrade *upgradeTask;
@end
