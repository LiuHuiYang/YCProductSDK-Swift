//
//  YCQueryViewController.swift
//  SwiftDemo
//
//  Created by macos on 2021/11/20.
//

import UIKit
import YCProductSDK

class YCQueryViewController: UIViewController {
    
    /// 设置选项
    private lazy var items = [
        "Basic info",
        "Mac address",
        "Device model",
        "HR",
        "BP",
        "User configuration",
        "Theme",
        "Electrode position",
        "Screen info",
        "Real timee xercise",
        "History summary",
        "Real time temperature",
        "Screen display info",
        
        "BloodOxygen",
        "Ambient light",
        "Temperature humidity",
        "Sensor sample info",
        "Work mode",
        "Upload reminder info",
        "MCU"
    ]
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Query"
        listView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableView.self))
    }

}

extension YCQueryViewController {
    
    func exampleForItems(_ index: Int) {
        
        self.textView.text = "";
        
        switch index {
        case 0:     // basic info
            YCProduct.queryDeviceBasicInfo { state, response in
                
                if state == YCProductState.succeed,
                 let info = response as? YCDeviceBasicInfo {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 1: // macaddress
            YCProduct.queryDeviceMacAddress { state, response in
                
                if state == YCProductState.succeed,
                   let macaddress = response as? String {
                    
                    self.textView.text = macaddress
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 2: // DeviceModel
            YCProduct.queryDeviceModel { state, response in
                
                if state == YCProductState.succeed,
                   let name = response as? String {
                    
                    self.textView.text = name
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 3:
            YCProduct.queryDeviceCurrentHeartRate { state, response in
                
                if state == YCProductState.succeed,
                   let info = response as? YCDeviceCurrentHeartRate {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 4:
            YCProduct.queryDeviceCurrentBloodPressure { state, response in
                
                if state == YCProductState.succeed,
                   let info = response as? YCDeviceCurrentBloodPressure {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 5:
            YCProduct.queryDeviceUserConfiguration { state, response in
                
                if state == .succeed,
                   let info = response as? YCProductUserConfiguration {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 6:
            YCProduct.queryDeviceTheme { state, response in
                
                if state == YCProductState.succeed,
                   let info = response as? YCDeviceTheme {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 7:
            YCProduct.queryDeviceElectrodePosition { state, response in
                
                if state == .succeed,
                let info = response as? YCDeviceElectrodePosition {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 8:
            YCProduct.queryDeviceScreenInfo { state, response in
                
                if state == .succeed,
                let info = response as? YCDeviceScreenInfo {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 9:
            YCProduct.queryDeviceCurrentExerciseInfo { state, response in
                
                if state == .succeed,
                let info = response as? YCDeviceCurrentExercise {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 10:
            YCProduct.queryDeviceHistorySummary { state, response in
                
                if state == .succeed,
                let info = response as? YCDeviceHistorySummary {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 11:
            YCProduct.queryDeviceRealTimeTemperature { state, response in
                if state == .succeed,
                   let temperature = response as? Double {
                    
                    self.textView.text = "\(temperature)"
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 12:
            YCProduct.queryDeviceScreenDisplayInfo { state, response in
                
                if state == .succeed,
                   let info = response as? YCDeviceScreenDisplayInfo {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 13:
            YCProduct.queryDeviceBloodOxygen { state, response in
                
                if state == .succeed,
                let info = response as? YCDeviceBloodOxygen {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 14:
            YCProduct.queryDeviceAmbientLight { state, response in
                
                if state == .succeed,
                let info = response as? YCDeviceAmbientLight {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 15:
            YCProduct.queryDeviceTemperatureHumidity { state, response in
                
                if state == .succeed,
                let info = response as? YCDeviceTemperatureHumidity {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 16:
            YCProduct.queryDeviceSensorSampleInfo(dataType: YCDeviceDataCollectionType.ppg) { state, response in
                
                if state == .succeed,
                let info = response as? YCDeviceSensorSampleInfo {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 17:
            YCProduct.queryDeviceWorkMode { state, response in
                
                if state == .succeed,
                let info = response as? YCDeviceWorkModeType {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 18:
            YCProduct.queryDeviceUploadReminderInfo { state, response in
                
                if state == .succeed,
                   let info = response as? YCDeviceUploadReminderInfo {
                    
                    self.textView.text = info.toString
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 19:
            YCProduct.queryDeviceMCU { state, response in
                
                if state == .succeed,
                let mcu = response as? YCDeviceMCUType{
                    
                    self.textView.text = mcu.toString
                
                } else if state == .unavailable {
                    
                    self.textView.text = YCProduct.shared.currentPeripheral?.mcu.toString
                }
            }
            
        case 20:
            YCProduct.queryDeviceRemindSettingInfo(dataType: .deviceDisconnected) { state, response in
                
                if state == .succeed,
                   let state = response as? YCDeviceReminderSettingState
                { 
                    self.textView.text = "Event state: \(state == .on)"
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        default:
            break
        }
    }
    
    private func showState(_ state: YCProductState) {
        
        if state == .succeed {
            MBProgressHUD.wj_showSuccess(nil)
        } else if state == .unavailable {
            self.textView.text = "Not support"
        } else if state == .failed {
            MBProgressHUD.wj_showError()
        }
    }
}

extension YCQueryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        exampleForItems(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
            return 0
        } else if indexPath.row == 4 {
            return 0
        } else if indexPath.row == 6,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportTheme != true {
            
            return 0
        
        } else if indexPath.row == 7,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportRealTimeECG != true {
            
            return 0
        
        } else if indexPath.row == 8 ||
                    indexPath.row == 9 ||
                    indexPath.row == 10 {
            
            return 0
            
        } else if indexPath.row == 11,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportAxillaryTemperatureMeasurement != true {
            
            return 0
        } else if indexPath.row >= 12 &&
                    indexPath.row <= 18 {
            
            return 0
        }
        
        return 49
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableView.self), for: indexPath)
        
        cell.textLabel?.text = // "\(indexPath.row + 1). " +
            items[indexPath.row]
        
        
        if indexPath.row == 6 {
          
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportTheme != true
        
        } else if indexPath.row == 7 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportRealTimeECG != true
        
        } else if indexPath.row == 8 ||
                    indexPath.row == 9 ||
                    indexPath.row == 10 {
            
            cell.isHidden = true
            
        } else if indexPath.row == 11 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportAxillaryTemperatureMeasurement != true
            
        } else if indexPath.row >= 12 &&
                    indexPath.row <= 18 {
            
            cell.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
