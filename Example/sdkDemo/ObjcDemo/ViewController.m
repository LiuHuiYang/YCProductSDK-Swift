//
//  ViewController.m
//  ObjcDemo
//
//  Created by macos on 2021/11/29.
//

#import "ViewController.h"
@import YCProductSDK;
@import CoreBluetooth;
#import "ObjcDemo-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc {
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivceData:) name:YCProduct.receivedRealTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleStateChanged:) name:YCProduct.deviceStateNotification object:nil];
}

- (void)receivceData:(NSNotification *)ntf {
    
    NSDictionary *info = ntf.userInfo;
   
    NSString *key =
        [NSString stringWithFormat:@"%d", YCReceivedRealTimeDataTypeEcg];
  
    YCReceivedDeviceReportInfo *reportData = [info objectForKey:key];
    
    NSArray *ecgData = [NSArray arrayWithObject:reportData.data];
    
    NSLog(@"%@", ecgData);
     
}

- (void)bleStateChanged:(NSNotification *)ntf {

    NSDictionary *info = ntf.userInfo;
//    CBPeripheral *obj = info[YCProduct.connectDeviceKey];
 
//    NSLog(@" == %@, %@", obj.name, @(state));
    
     id obj = info[YCProduct.connecteStateKey];
     
   NSInteger st =  [YCDeviceTools getSwiftValueRawValue:obj];
    
    NSLog(@"st = %zd", st);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [YCProduct queryDeviceElectrodePosition:nil completion:^(enum YCProductState state, id _Nullable response)  {
        
        NSLog(@"==== %@", response);
        
    }];
//    
//    return;
    
//    [YCProduct queryDeviceRealTimeTemperature:nil completion:^(enum YCProductState state, id _Nullable response) {
//
//        NSLog(@"==== %@", response);
//
//    }];
    
    return;
    
    [YCProduct startECGMeasurement:YCProduct.shared.currentPeripheral completion:^(enum YCProductState state, id _Nullable response) {
        
        if (state == YCProductStateSucceed) {
            
            NSLog(@"????????????");
        }
        
    }];
    
    
//    [YCProduct queryHealthData:YCProduct.shared.currentPeripheral datatType:YCQueryHealthDataTypeHeartRate completion:^(enum YCProductState sate, id _Nullable res) {
//
//    }];
    
//    [YCProduct queryCollectDataBasicinfo:YCProduct.shared.currentPeripheral dataType:YCCollectDataTypeEcg completion:^(enum YCProductState, id _Nullable) {
//
//    }];
    
//    [YCProduct realTimeDataUplod:nil isEnable:true dataType:YCRealTimeDataTypeStep interval:2.0 completion:^(enum YCProductState sate, id _Nullable dats) {
//
//    }];
    
//    [YCProduct startECGMeasurement:nil completion:^(enum YCProductState, id _Nullable) {
//
//    }];
    
    
    
    [YCProduct scanningDeviceWithDelayTime:3.0 completion:^(NSArray<CBPeripheral *> * _Nonnull datas, NSError * _Nullable error) {

        NSLog(@"%@", datas);
    }];
    
//    [YCProduct queryWatchFaceInfo:nil completion:^(enum YCProductState state, id _Nullable data) {
//
//    }];
     
    
     
}


@end
