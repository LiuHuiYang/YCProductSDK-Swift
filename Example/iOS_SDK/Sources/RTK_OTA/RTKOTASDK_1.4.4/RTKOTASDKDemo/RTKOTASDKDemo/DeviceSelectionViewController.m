//
//  DeviceSelectionViewController.m
//  RTKOTASDKDemo
//
//  Created by jerome_gu on 2021/11/18.
//  Copyright © 2021 Realtek. All rights reserved.
//

#import "DeviceSelectionViewController.h"
#import <ExternalAccessory/ExternalAccessory.h>

@interface DeviceSelectionViewController () <CBCentralManagerDelegate>
@property CBCentralManager *centralManager;
@property NSMutableArray <CBPeripheral*> *scanedPeripherals;
@property NSMutableArray <EAAccessory*> *connectedAccessories;
@end

@implementation DeviceSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Device select";
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"SystemCell"];
    
    self.scanedPeripherals = [NSMutableArray array];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    self.connectedAccessories = [NSMutableArray array];
    NSArray<EAAccessory *> *accessories = [EAAccessoryManager sharedAccessoryManager].connectedAccessories;
    for (EAAccessory *accessory in accessories) {
        if ([accessory.protocolStrings containsObject:@"com.rtk.datapath"]) {
            [self.connectedAccessories addObject:accessory];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self beginListeningForConnectionWithAccessory];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopListeningForConnectionWithAccessory];
}

- (void)dealloc {
    if (self.centralManager.isScanning)
        [self.centralManager stopScan];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.connectedAccessories.count : self.scanedPeripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        EAAccessory *accessory = self.connectedAccessories[indexPath.row];
        cell.textLabel.text = accessory.name;
    } else if (indexPath.section == 1) {
        CBPeripheral *peripheral = self.scanedPeripherals[indexPath.row];
        cell.textLabel.text = peripheral.name ? peripheral.name : @"Unnamed";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EAAccessory *accessory = self.connectedAccessories[indexPath.row];
        
        if (self.selectionHandler) {
            self.selectionHandler(accessory);
        }
    } else if (indexPath.section == 1) {
        CBPeripheral *peripheral = self.scanedPeripherals[indexPath.row];
        
        if (self.selectionHandler) {
            self.selectionHandler(peripheral);
        }
    }
}

#pragma mark - CBCentralManager
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
        [self.scanedPeripherals removeAllObjects];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [central scanForPeripheralsWithServices:self.serviceUUIDs options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    for (int i = 0; i<self.scanedPeripherals.count; i++) {
        CBPeripheral *scanedPeripheral = self.scanedPeripherals[i];
        if ([scanedPeripheral.identifier isEqual:peripheral]) {
            [self.scanedPeripherals replaceObjectAtIndex:i withObject:peripheral];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
    }
    
    [self.scanedPeripherals addObject:peripheral];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.scanedPeripherals.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - EA accessory
- (void)beginListeningForConnectionWithAccessory {
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
}

- (void)stopListeningForConnectionWithAccessory {
    [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
}

- (void)accessoryDidConnect:(NSNotification *)notification {
    EAAccessory *connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    if ([connectedAccessory.protocolStrings containsObject:@"com.rtk.datapath"]) {
        [self.connectedAccessories addObject:connectedAccessory];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.connectedAccessories.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)accessoryDidDisconnect:(NSNotification *)notification {
    EAAccessory *disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    if ([self.connectedAccessories containsObject:disconnectedAccessory]) {
        NSUInteger toDeleteIndex = [self.connectedAccessories indexOfObject:disconnectedAccessory];
        [self.connectedAccessories removeObject:disconnectedAccessory];
        
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:toDeleteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
