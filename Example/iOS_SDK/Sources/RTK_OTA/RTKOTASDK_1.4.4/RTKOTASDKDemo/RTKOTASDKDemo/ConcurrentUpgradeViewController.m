//
//  ConcurrentUpgradeViewController.m
//  RTKOTASDKDemo
//
//  Created by jerome_gu on 2021/11/18.
//  Copyright © 2021 Realtek. All rights reserved.
//

#import "ConcurrentUpgradeViewController.h"
#import <RTKOTASDK/RTKOTASDK.h>
#import "DeviceSelectionViewController.h"

@interface ConcurrentUpgradeViewController () <RTKDFUUpgradeDelegate, RTKFileBrowseViewControllerDelegate>
@property NSMutableArray <RTKDFUUpgrade*> *upgradeTasks;
@property NSPointerArray *binaryFilePaths;
@end

@implementation ConcurrentUpgradeViewController {
    NSUInteger _selectBinaryFileForUpgradeIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.upgradeTasks = [NSMutableArray array];
    self.binaryFilePaths = [NSPointerArray strongObjectsPointerArray];
}

- (IBAction)addButtonAction:(id)sender {
    DeviceSelectionViewController *deviceSelectionVC = [[DeviceSelectionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    deviceSelectionVC.serviceUUIDs = @[[CBUUID UUIDWithString:@"000002FD-3C17-D293-8E48-14FE2E4DA212"], [CBUUID UUIDWithString:@"010002FD-3C17-D293-8E48-14FE2E4DA212"]];
    
    deviceSelectionVC.selectionHandler = ^(id  _Nonnull device) {
        RTKDFUUpgrade *newUpgrade;
        if ([device isKindOfClass:CBPeripheral.class]) {
            newUpgrade = [[RTKDFUUpgrade alloc] initWithPeripheral:device];
        } else if ([device isKindOfClass:EAAccessory.class]) {
            newUpgrade = [[RTKDFUUpgrade alloc] initWithAccessory:device];
        }
        
        [self.binaryFilePaths addPointer:NULL];
        
        [self.upgradeTasks addObject:newUpgrade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.upgradeTasks.count-1] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
        newUpgrade.delegate = self;
        [newUpgrade prepareForUpgrade];
    };
    
    [self.navigationController pushViewController:deviceSelectionVC animated:YES];
}

- (IBAction)startButtonAction:(UIButton *)sender {
    sender.enabled = NO;
    
    UITableViewCell *cell = sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *filePath = [self.binaryFilePaths pointerAtIndex:indexPath.section];
    [self.upgradeTasks[indexPath.section] upgradeWithBinaryFileAtPath:filePath];
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    sender.enabled = NO;
    
    UITableViewCell *cell = sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.upgradeTasks[indexPath.section] cancelUpgrade];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.upgradeTasks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTKDFUUpgrade *upgrade = self.upgradeTasks[indexPath.section];
    
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell" forIndexPath:indexPath];
            cell.detailTextLabel.text = upgrade.deviceConnection.deviceName;
            cell.accessoryType = upgrade.deviceInfo ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
        }
            break;
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell" forIndexPath:indexPath];
            NSString *filePath = [self.binaryFilePaths pointerAtIndex:indexPath.section];
            cell.detailTextLabel.text = filePath.lastPathComponent;
            cell.accessoryType = filePath != nil ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"StatusCell" forIndexPath:indexPath];
            UILabel *statusLabel = [cell.contentView viewWithTag:10];
            statusLabel.text = upgrade.upgradingImage ? @"" : @"";
            UIProgressView *progressView = [cell.contentView viewWithTag:40];
            progressView.progress = upgrade.progress.fractionCompleted;
        }
            break;
        case 3:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell" forIndexPath:indexPath];
            UILabel *startButton = [cell.contentView viewWithTag:20];
            UILabel *cancelButton = [cell.contentView viewWithTag:21];
            startButton.hidden = upgrade.upgradeInProgress;
            cancelButton.hidden = !upgrade.upgradeInProgress;
            
            NSString *filePath = [self.binaryFilePaths pointerAtIndex:indexPath.section];;
            startButton.enabled = upgrade.deviceInfo && filePath != nil;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        _selectBinaryFileForUpgradeIndex = indexPath.section;
        
//        NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//        docDir = [docDir stringByAppendingPathComponent:@"firmwares"];
//        RTKFileBrowseViewController *fileVC = [[RTKFileBrowseViewController alloc] initWithRootPath:docDir];
        RTKFileBrowseViewController *fileVC = [[RTKFileBrowseViewController alloc] init];
        fileVC.style = RTKFileBrowseStyleSelection;
        fileVC.delegate = self;
        fileVC.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:fileVC animated:YES completion:nil];
    }
}


#pragma mark - RTKDFUUpgradeDelegate

- (void)DFUUpgradeDidReadyForUpgrade:(RTKDFUUpgrade *)task {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.upgradeTasks indexOfObject:task]] withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (void)DFUUpgrade:(RTKDFUUpgrade *)task couldNotUpgradeWithError:(NSError *)error {
    
}

- (void)DFUUpgrade:(RTKDFUUpgrade *)task
        withDevice:(RTKProfileConnection *)connection
  didSendBytesCount:(NSUInteger)length
           ofImage:(RTKOTAUpgradeBin *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:[self.upgradeTasks indexOfObject:task]]] withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (void)DFUUpgrade:(RTKDFUUpgrade *)task didFinishUpgradeWithError:(nullable NSError *)err {
    
}


- (void)fileBrowseViewController:(RTKFileBrowseViewController *)browser didSelectRegularFileAtPath:(NSString *)path {
    [self.binaryFilePaths replacePointerAtIndex:_selectBinaryFileForUpgradeIndex withPointer:CFBridgingRetain(path)];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:_selectBinaryFileForUpgradeIndex] withRowAnimation:UITableViewRowAnimationFade];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
