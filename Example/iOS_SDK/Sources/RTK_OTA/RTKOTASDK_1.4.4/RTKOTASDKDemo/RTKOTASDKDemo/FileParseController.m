//
//  FileParseController.m
//  RTKOTASDKDemo
//
//  Created by irene_wang on 2021/4/6.
//  Copyright © 2021 Realtek. All rights reserved.
//


#import "FileParseController.h"
#import "OTADemoViewController.h"
#import "SVProgressHUD.h"

@interface FileParseController ()
@property NSArray <RTKOTAUpgradeBin*> *primaryBins;
@property NSArray <RTKOTAUpgradeBin*> *secondaryBins;
@property NSArray <RTKOTAUpgradeBin*> *packBins;
@property BOOL flag_parsePack;
@property BOOL flag_parseCombine;
@property (weak, nonatomic) IBOutlet UIButton *ParsePackFileButton;
@property (weak, nonatomic) IBOutlet UIButton *ParseCombineFileButton;
@property (weak, nonatomic) IBOutlet UITableView *fileInfoTableView;
@end

@implementation FileParseController
    
- (IBAction)clickToParsePackFile:(id)sender {
    self.flag_parsePack = YES;
    self.flag_parseCombine = NO;
    
    NSError *error;
    NSString *_filePath = [[NSBundle mainBundle] pathForResource:@"RTBT-62M-DELTA-EVCS-v0.0.4" ofType:@"bin"]; //You can replace the filePath with your own
    self.packBins = [RTKOTAUpgradeBin imagesExtractedFromMPPackFilePath:_filePath error:&error];
    if (self.packBins.count == 1 && !self.packBins.lastObject.ICDetermined) {
        [self.packBins.lastObject assertAvailableForPeripheralInfo:self.upgradeTask.deviceInfo];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fileInfoTableView reloadData];
    });
}

- (IBAction)clickToParseCombineFile:(id)sender {
    self.flag_parsePack = NO;
    self.flag_parseCombine = YES;
    
    NSString *_filePath = [[NSBundle mainBundle] pathForResource:@"2926-combined" ofType:@"bin"];
    NSArray <RTKOTAUpgradeBin*> *primaryBins, *secondaryBins;
    NSError *err = [RTKOTAUpgradeBin extractCombinePackFileWithFilePath:_filePath toPrimaryBudBins:&primaryBins secondaryBudBins:&secondaryBins];
    if (!err) {
        self.primaryBins = primaryBins;
        self.secondaryBins = secondaryBins;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fileInfoTableView reloadData];
    });
}


#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.flag_parsePack) {
        return 1;
    }
    if (self.flag_parseCombine) {
        return 2;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.flag_parsePack && section == 0) {
        return self.packBins.count;
    }
    if (self.flag_parseCombine && section == 0) {
        return self.primaryBins.count;
    }
    if (self.flag_parseCombine && section == 1) {
        return self.secondaryBins.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.flag_parsePack && section == 0) {
        return @"Pack Bins";
    }
    
    if (self.flag_parseCombine && section == 0) {
        return @"Primary Bins";
    }
    
    if (self.flag_parseCombine && section == 1) {
        return @"Secondary Bins";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (self.flag_parsePack && indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.packBins.count == 0) {
            cell.textLabel.text = @" ";
        } else {
            RTKOTAUpgradeBin *bin = self.packBins[indexPath.row];
            if (bin.upgradeBank == RTKOTAUpgradeBank_Bank1) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ - Bank1",bin.name];
            } else if (bin.upgradeBank == RTKOTAUpgradeBank_SingleOrBank0){
                cell.textLabel.text = [NSString stringWithFormat:@"%@ - Bank0",bin.name];
            } else if (bin.upgradeBank == RTKOTAUpgradeBank_Unknown){
                cell.textLabel.text = [NSString stringWithFormat:@"%@ - Unknown",bin.name];
            }
            cell.detailTextLabel.text = bin.versionString;
        }
    }
    
    if (self.flag_parseCombine && indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.primaryBins.count == 0) {
            cell.textLabel.text = @" ";
        } else {
            RTKOTAUpgradeBin *primaryBin = self.primaryBins[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - Bank%lu",primaryBin.name,(unsigned long)primaryBin.upgradeBank-1];
            cell.detailTextLabel.text = primaryBin.versionString;
        }
    }
    
    if (self.flag_parseCombine && indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.secondaryBins.count == 0) {
            cell.textLabel.text = @" ";
        } else {
            RTKOTAUpgradeBin *secondaryBin = self.secondaryBins[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - Bank%lu",secondaryBin.name,(unsigned long)secondaryBin.upgradeBank-1];
            cell.detailTextLabel.text = secondaryBin.versionString;
        }
    }

    return cell;
}

@end
