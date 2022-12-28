//
//  DeviceInfoViewController.m
//  RTKOTASDKDemo
//
//  Created by irene_wang on 2021/4/6.
//  Copyright © 2021 Realtek. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "OTADemoViewController.h"
#import "SVProgressHUD.h"

@interface DeviceInfoViewController ()
@end

@implementation DeviceInfoViewController 

- (void)viewDidAppear:(BOOL)animated {
    if (!self.upgradeTask) {
        [SVProgressHUD showErrorWithStatus:@"Please connect to the device first"];
        [SVProgressHUD dismissWithDelay:1.0 completion:^{
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.upgradeTask && self.upgradeTask.deviceInfo.activeBank < RTKOTABankTypeBank0 ) {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 14;
    } else if (section == 1) {
        return self.upgradeTask.deviceInfo.bins.count;
    } else if (section == 2 ) {
        return self.upgradeTask.deviceInfo.inactiveBins.count;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"General Info";
    } else if (section == 1) {
        return @"Active Bank Images";
    } else if (section == 2 ) {
        return @"Inactive Bank Images";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Protocol";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.upgradeTask.deviceInfo.protocolType];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"OTAVersion";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.upgradeTask.deviceInfo.OTAVersion];
        } if (indexPath.row == 2) {
            cell.textLabel.text = @"BdAddress";
            cell.detailTextLabel.text = BDAddressString(self.upgradeTask.deviceInfo.bdAddress);
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"PairedBDAddress";
            cell.detailTextLabel.text = BDAddressString(self.upgradeTask.deviceInfo.companionBDAddress);
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"TempBufferSize";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.upgradeTask.deviceInfo.tempBufferSize];
        } else if (indexPath.row == 5) {
            cell.textLabel.text = @"ActiveBank";
            if (self.upgradeTask.deviceInfo.activeBank == RTKOTABankTypeInvalid) {
                cell.detailTextLabel.text = @"Invalid";
            } else if (self.upgradeTask.deviceInfo.activeBank == RTKOTABankTypeSingle) {
                cell.detailTextLabel.text = @"Single";
            } else if (self.upgradeTask.deviceInfo.activeBank == RTKOTABankTypeBank0) {
                cell.detailTextLabel.text = @"Bank0";
            } else if (self.upgradeTask.deviceInfo.activeBank == RTKOTABankTypeBank1) {
                cell.detailTextLabel.text = @"Bank1";
            }
        } else if (indexPath.row == 6) {
            cell.textLabel.text = @"BuffercheckEnable";
            cell.detailTextLabel.text = self.upgradeTask.deviceInfo.bufferCheckEnable ? @"Yes": @"No";
        } else if (indexPath.row == 7) {
            cell.textLabel.text = @"AESEnable";
            cell.detailTextLabel.text = self.upgradeTask.deviceInfo.AESEnable ? @"Yes": @"No";
        } else if (indexPath.row == 8) {
            cell.textLabel.text = @"EncryptionMode";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.upgradeTask.deviceInfo.encryptionMode];
        } else if (indexPath.row == 9) {
            cell.textLabel.text = @"CopyImage";
            cell.detailTextLabel.text = self.upgradeTask.deviceInfo.copyImage ? @"Yes": @"No";
        } else if (indexPath.row == 10) {
            cell.textLabel.text = @"UpdateMultiImages";
            cell.detailTextLabel.text = self.upgradeTask.deviceInfo.updateMultiImages ? @"Yes": @"No";
        } else if (indexPath.row == 11) {
            cell.textLabel.text = @"IsRWS";
            cell.detailTextLabel.text = self.upgradeTask.deviceInfo.isRWSMember ? @"Yes": @"No";
        } else if (indexPath.row == 12) {
            cell.textLabel.text = @"BudType";
            if (self.upgradeTask.deviceInfo.budType == RTKOTAEarbudUnkown) {
                cell.detailTextLabel.text = @"Unkown";
            } else if (self.upgradeTask.deviceInfo.budType == RTKOTAEarbudSingle) {
                cell.detailTextLabel.text = @"Single";
            } else if (self.upgradeTask.deviceInfo.budType == RTKOTAEarbudPrimary) {
                cell.detailTextLabel.text = @"Primary";
            } else if (self.upgradeTask.deviceInfo.budType == RTKOTAEarbudSecondary) {
                cell.detailTextLabel.text = @"Secondary";
            }
        } else if (indexPath.row == 13) {
            cell.textLabel.text = @"Engaged";
            cell.detailTextLabel.text = self.upgradeTask.deviceInfo.engaged? @"Yes": @"No";
        }
    } else if (indexPath.section == 1) {
        RTKOTABin *bin = self.upgradeTask.deviceInfo.bins[indexPath.row];
        cell.textLabel.text = bin.name;
        cell.detailTextLabel.text = bin.versionString;
    } else if (indexPath.section == 2) {
        RTKOTABin *bin = self.upgradeTask.deviceInfo.inactiveBins[indexPath.row];
        cell.textLabel.text = bin.name;
        cell.detailTextLabel.text = bin.versionString;
    }

    return cell;
}

@end


