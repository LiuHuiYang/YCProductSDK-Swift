//
//  OTADemoViewController.m
//  RTKOTASDKDemo
//
//  Created by irene_wang on 2021/4/2.
//  Copyright © 2021 Realtek. All rights reserved.
//

#import "OTADemoViewController.h"
#import "DeviceInfoViewController.h"
#import "FileParseController.h"
#import "UpgradeController.h"
#import "SVProgressHUD.h"

@interface OTADemoViewController ()
@end

@implementation OTADemoViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTextLabel.text = self.upgradeTask.deviceConnection && self.upgradeTask.deviceConnection.status == RTKProfileConnectionStatusActive? self.upgradeTask.deviceConnection.deviceName: @"";
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinationVC = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"ParseDeviceInfo"]) {
        if ([destinationVC respondsToSelector:@selector(setUpgradeTask:)]) {
            [(DeviceInfoViewController *)destinationVC setUpgradeTask:self.upgradeTask];
        }
    } else if ([segue.identifier isEqualToString:@"ParseFile"]) {
        if ([destinationVC respondsToSelector:@selector(setUpgradeTask:)]) {
            [(FileParseController *)destinationVC setUpgradeTask:self.upgradeTask];
        }
    } else if ([segue.identifier isEqualToString:@"Upgrade"]) {
        if ([destinationVC respondsToSelector:@selector(setUpgradeTask:)]) {
            [(UpgradeController *)destinationVC setUpgradeTask:self.upgradeTask];
        }
    }
}

@end
