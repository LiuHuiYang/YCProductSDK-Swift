//
//  UpgradeController.m
//  RTKOTASDKDemo
//
//  Created by irene_wang on 2021/4/7.
//  Copyright © 2021 Realtek. All rights reserved.
//

#import "UpgradeController.h"
#import "OTADemoViewController.h"
#import "SVProgressHUD.h"

@interface UpgradeController ()<RTKDFUUpgradeDelegate>
@property NSArray <RTKOTAUpgradeBin*> *packBins;
@property NSArray <RTKOTAUpgradeBin*> *primaryBins;
@property NSArray <RTKOTAUpgradeBin*> *secondaryBins;
@property (weak, nonatomic) IBOutlet UIButton *upgradeBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *upgradeProgress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation UpgradeController 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.upgradeTask.delegate = self;
    [RTKLog setLogLevel:RTKLogLevelVerbose];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.upgradeTask) {
        self.upgradeBtn.enabled = NO;
        [SVProgressHUD showErrorWithStatus:@"No device connected, please connect to the device first"];
        [SVProgressHUD dismissWithDelay:2.0 completion:^{
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }
}

- (void)combineFileParse {
    NSString *_filePath = [[NSBundle mainBundle] pathForResource:@"2926-combined" ofType:@"bin"];
    NSArray <RTKOTAUpgradeBin*> *primaryBins, *secondaryBins;
    NSError *err = [RTKOTAUpgradeBin extractCombinePackFileWithFilePath:_filePath toPrimaryBudBins:&primaryBins secondaryBudBins:&secondaryBins];
    if (!err) {
        self.primaryBins = primaryBins;
        self.secondaryBins = secondaryBins;
    }
}

- (void)packFileParse {
    NSError *error;
    NSString *_filePath = [[NSBundle mainBundle] pathForResource:@"RTBT-62M-DELTA-EVCS-v0.0.4" ofType:@"bin"];
    self.packBins = [RTKOTAUpgradeBin imagesExtractedFromMPPackFilePath:_filePath error:&error];
    if (self.packBins.count == 1 && !self.packBins.lastObject.ICDetermined) {
        [self.packBins.lastObject assertAvailableForPeripheralInfo:self.upgradeTask.deviceInfo];
    }
}


- (IBAction)clickToStart:(id)sender {
    self.upgradeBtn.enabled = NO;
    [self combineFileParse];
    [self packFileParse];
    
/*
 不检查升级文件版本
    self.upgradeTask.olderImageAllowed = YES;
 设置升级模式为普通升级
    [(RTKDFUUpgradeGATT*)self.upgradeTask setPrefersUpgradeUsingOTAMode:YES];
 */

    self.upgradeTask.usingStrictImageCheckMechanism = YES;  //严格检查升级文件版本
    self.upgradeTask.batteryLevelLimit = 0; //电量检查
    
    if (self.upgradeTask.deviceInfo.isRWSMember) {
        [self.upgradeTask upgradeWithImagesForPrimaryBud:self.primaryBins imagesForSecondaryBud:self.secondaryBins];
    } else {
        [self.upgradeTask upgradeWithImages:self.packBins];
    }
    
}

#pragma mark - RTKDFUUpgradeDelegate
- (void)DFUUpgrade:(RTKDFUUpgrade *)task isAboutToSendImageBytesTo:(RTKProfileConnection *)connection withContinuationHandler:(void(^)(void))continuationHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        continuationHandler();
    });
}


- (void)DFUUpgrade:(RTKDFUUpgrade *)task
        withDevice:(RTKProfileConnection *)connection
 didSendBytesCount:(NSUInteger)length
           ofImage:(RTKOTAUpgradeBin *)image {
    self.progressLabel.text = [NSString stringWithFormat:@"Upgrading %@ image (%ld/%ld)", image.name, length, image.data.length];
}

- (void)DFUUpgrade:(RTKDFUUpgrade *)task withDevice:(RTKProfileConnection *)connection willSendImage:(RTKOTAUpgradeBin *)image {
    self.progressLabel.text = [NSString stringWithFormat:@"Sending %@", image.name];
}

- (void)DFUUpgrade:(RTKDFUUpgrade *)task
        withDevice:(RTKProfileConnection *)connection
didCompleteSendImage:(RTKOTAUpgradeBin *)image {
    self.progressLabel.text = [NSString stringWithFormat:@"Did finish send %@", image.name];
    self.upgradeProgress.progress = task.progress.fractionCompleted;
}


- (void)DFUUpgrade:(RTKDFUUpgrade *)task withDevice:(RTKProfileConnection *)connection didActivateImages:(NSSet<RTKOTAUpgradeBin*>*)images {
    self.progressLabel.text = [NSString stringWithFormat:@"Activate images"];
}

- (void)DFUUpgrade:(RTKDFUUpgrade *)task didFinishUpgradeWithError:(nullable NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            self.progressLabel.text = @"Upgrade failed";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERROR" message:error.description preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            self.progressLabel.text = @"Upgrade Success";
        }
        
        [SVProgressHUD dismissWithDelay:2.0 completion:^{
            OTADemoViewController *homeView = [self.navigationController.viewControllers objectAtIndex:0];
            if ([homeView respondsToSelector:@selector(setUpgradeTask:)]) {
                [homeView setUpgradeTask:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    });
}

- (void)DFUUpgradeDidFinishFirstDeviceAndPrepareCompanionDevice:(RTKDFUUpgrade *)task {
    self.progressLabel.text = @"Connecting to companion device";
}

- (void)DFUUpgrade:(RTKDFUUpgrade *)task
willUpgradeCompanionDevice:(RTKProfileConnection *)connection
        deviceInfo:(RTKOTADeviceInfo *)companionInfo {
    self.progressLabel.text = @"Start upgrade companion device";
}


@end
