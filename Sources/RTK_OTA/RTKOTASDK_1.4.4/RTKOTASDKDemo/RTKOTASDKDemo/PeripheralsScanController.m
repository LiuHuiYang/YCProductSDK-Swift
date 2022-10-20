//
//  PeripheralsScanController.m
//  RTKOTASDKDemo
//
//  Created by irene_wang on 2021/5/21.
//  Copyright © 2021 Realtek. All rights reserved.
//

#import "PeripheralsScanController.h"
#import "OTADemoViewController.h"
#import "SVProgressHUD.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralsScanController () <CBCentralManagerDelegate, RTKDFUUpgradeDelegate>
@property (nonatomic) RTKDFUUpgrade *upgradeTask;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property NSMutableArray <CBPeripheral*> *discoveredPeripheralConnections;
@property CBPeripheral* selectedDevice;
@end

@implementation PeripheralsScanController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.discoveredPeripheralConnections) {
        self.discoveredPeripheralConnections = [NSMutableArray arrayWithCapacity:12];
    }
    if (!self.centralManager) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.discoveredPeripheralConnections removeAllObjects];
    [self.tableView reloadData];
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)dealloc {
    if (self.centralManager.isScanning)
        [self.centralManager stopScan];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.discoveredPeripheralConnections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PeripheralCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PeripheralCell"];
    }
    cell.textLabel.text =self.discoveredPeripheralConnections[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.centralManager.isScanning)
        [self.centralManager stopScan];

    self.selectedDevice = self.discoveredPeripheralConnections[indexPath.row];
    [SVProgressHUD showWithStatus:@"Connecting..."];
    self.upgradeTask = [[RTKDFUUpgrade alloc] initWithPeripheral:self.selectedDevice];
    self.upgradeTask.delegate = self;
    [self.upgradeTask prepareForUpgrade];
}


#pragma mark - CBCentralManager
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
//        [self.discoveredPeripheralConnections removeAllObjects];
//        [self.peripheralRSSI removeAllObjects];
//        [self.tableView reloadData];
//
//        [central scanForPeripheralsWithServices:nil options:nil];
    }
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    RTKLogInfo(@"A new peripheral is scanned.(name:%@ identifier:%@ RSSI:%d adv:%@)",peripheral.name, peripheral.identifier, RSSI.intValue,advertisementData);
    int connectable = 0;
    if ([[advertisementData allKeys] containsObject:@"kCBAdvDataIsConnectable"]) {
        connectable = [[advertisementData valueForKey:@"kCBAdvDataIsConnectable"] intValue];
    }
    if (!peripheral.name || RSSI.intValue < -85 || connectable != 1) {
        return;
    }
    
    for (int i = 0; i<self.discoveredPeripheralConnections.count; i++) {
        CBPeripheral *scanedPeripheral = self.discoveredPeripheralConnections[i];
        if ([scanedPeripheral.identifier isEqual:peripheral.identifier]) {
            [self.discoveredPeripheralConnections replaceObjectAtIndex:i withObject:peripheral];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            return;
        }
    }

    [self.discoveredPeripheralConnections addObject:peripheral];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


#pragma mark - RTKDFUUpgradeDelegate
- (void)DFUUpgradeDidReadyForUpgrade:(RTKDFUUpgrade *)task {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        OTADemoViewController *homeView = [self.navigationController.viewControllers objectAtIndex:0];
        [homeView setUpgradeTask:self.upgradeTask];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)DFUUpgrade:(RTKDFUUpgrade *)task couldNotUpgradeWithError:(NSError *)err {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        NSString *errorMessage = [NSString stringWithFormat:@"Preparing device for upgrade failed. %@",err.localizedDescription];
        [SVProgressHUD showErrorWithStatus:errorMessage];
        [SVProgressHUD dismissWithDelay:1.2];
        self.upgradeTask = nil;
    });
}

@end

