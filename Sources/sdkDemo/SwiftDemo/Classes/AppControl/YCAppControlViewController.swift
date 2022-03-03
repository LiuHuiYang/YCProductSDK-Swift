//
//  YCAppControlViewController.swift
//  SwiftDemo
//
//  Created by macos on 2021/12/6.
//

import UIKit
import YCProductSDK

private var state = false

class YCAppControlViewController: UIViewController {
    
    /// 设置选项
    private lazy var items = [
        "find device",
        "bp calibration",
        "temperature calibration",
        "armpit temperature measurement",
        "body temperature qrcode color",
        "weather",
        "turn off",
        "real step",
        "wave data upload",
        "heartRate measurement",
        "start run",
        "stop run",
        "photo",
        "health parameters",
        "friend message",
        "healthData writeback",
        "sleep data writeback",
        "person info writeback",
        "upgrade reminde writeback",
        "sportdata writeback",
        "caclulate hr",
        "measurementdata writeback",
        "sensor save data enable",
        "phone mode",
        "warning info",
        "show message",
        "temperature humidity calibration",
        "address book",
    ]
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var listView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "App control"
        
        listView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableView.self))
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveRealTimeData(_:)), name: YCProduct.receivedRealTimeNotification, object: nil)
        
        // 状态变化
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDataStateChanged(_:)), name: YCProduct.deviceControlNotification, object: nil)
    }
    
    /// 测量状态变化
    /// - Parameter ntf:
    @objc private func deviceDataStateChanged(_ ntf: Notification) {
        
        guard let info = ntf.userInfo else {
            return
        }
              
        if let result = ((info[YCDeviceControlType.healthDataMeasurementResult.string]) as? YCReceivedDeviceReportInfo)?.data as? YCDeviceControlMeasureHealthDataResultInfo {
                   
                print(result.state, result.dataType)
              }
         
        
        if let response = info[YCDeviceControlType.sportModeControl.string] as? YCReceivedDeviceReportInfo,
           let device = response.device,
           let data = response.data as? YCDeviceControlSportModeControlInfo {
            
            print(device.name ?? "",
                  data.state,
                  data.sportType
            )
        }
        
        
        // 拍照
        if let response = info[YCDeviceControlType.photo.string] as? YCReceivedDeviceReportInfo,
               let device = response.device,
               let state = response.data as? YCDeviceControlPhotoState {
                print(device.name ?? "",
                      state
                )
            
                self.textView.text = "photo: \(state.toString)"
            }
        
        // 找手机
        if let response = info[YCDeviceControlType.findPhone.string] as? YCReceivedDeviceReportInfo,
           let device = response.device,
           let state = response.data as? YCDeviceControlState {
        
            self.textView.text = (device.name ?? "") + "find phone state: \(state.toString)"
        }
        
        // sos
        if let response = info[YCDeviceControlType.sos.string] as? YCReceivedDeviceReportInfo,
           let device = response.device {    
          
            self.textView.text = (device.name ?? "") + "sos"
        }
        
        // 是否允许连接
        if let response = info[YCDeviceControlType.allowConnection.string] as? YCReceivedDeviceReportInfo,
           let device = response.device,
           let state = response.data as? YCDeviceControlAllowConnectionState {
            
            print(device.name ?? "",
                  state == .agree
            )
            
            self.textView.text = (device.name ?? "") + "allowConnection: \(state.toString)"
        }
        
        // 恢复出厂设置  reset
        if let response = info[YCDeviceControlType.reset.string] as? YCReceivedDeviceReportInfo,
           let device = response.device {
         
            
            self.textView.text = (device.name ?? "") + "reset"
        }
        
        // 预警值
        if let response = info[YCDeviceControlType.reportWarningValue.string] as? YCReceivedDeviceReportInfo,
           let device = response.device,
           let value = response.data as? YCDeviceControlReportWarningValueInfo {
            
            self.textView.text =
                (device.name ?? "") + "warning value: \(value)"
        }
        
    }
    
    @objc private func receiveRealTimeData(_ notification: Notification) {
        
        guard let info = notification.userInfo else {
            return
        }
        
        if let response = info[YCReceivedRealTimeDataType.step.string] as? YCReceivedDeviceReportInfo,
           let device = response.device,
           let sportInfo = response.data as? YCReceivedRealTimeStepInfo {
             
            self.textView.text =
                (device.name ?? "") + "\n" + sportInfo.toString
        }
        
        else if let response = info[YCReceivedRealTimeDataType.heartRate.string] as? YCReceivedDeviceReportInfo,
                let device = response.device,
                let heartRate = response.data as? UInt8 {
             
           
            self.textView.text = (device.name ?? "") + "\n" + "heartRate: \(heartRate)"
        }
        
        else if let response = info[YCReceivedRealTimeDataType.bloodOxygen.string] as? YCReceivedDeviceReportInfo,
                let device = response.device,
                let bloodOxygen = response.data as? UInt8 {
          
            self.textView.text = (device.name ?? "") + "\n" + "bloodOxygen: \(bloodOxygen)"
        }
        
        // 血压等组合
        else if let response =  info[YCReceivedRealTimeDataType.bloodPressure.string] as? YCReceivedDeviceReportInfo,
                let device = response.device,
                let bloodPressureInfo = response.data as? YCReceivedRealTimeBloodPressureInfo   {
            
            print(device.name ?? "",
                  bloodPressureInfo.systolicBloodPressure,
                  bloodPressureInfo.diastolicBloodPressure)
            
            self.textView.text = (device.name ?? "") + "\n" + bloodPressureInfo.toString
        }
        
        else if let response = info[YCReceivedRealTimeDataType.ppg.string] as? YCReceivedDeviceReportInfo,
                let device = response.device,
                let ppgData = response.data as? [Int32] {
            
//            print(device.name ?? "", ppgData)
        
            
            self.textView.text = (device.name ?? "") + "ppg: \n" +
                NSArray(array: ppgData).componentsJoined(by: "\n")
            
        }
        
        else if let response = info[YCReceivedRealTimeDataType.ecg.string] as? YCReceivedDeviceReportInfo,
                let device = response.device,
                let ecgData = response.data as? [Int32] {
            
//            print(device.name ?? "", ecgData)
            
            self.textView.text = (device.name ?? "") + "ecg: \n" +
                NSArray(array: ecgData).componentsJoined(by: "\n")
        }
        
        else if let response = info[YCReceivedRealTimeDataType.realTimeMonitoringMode.string] as? YCReceivedDeviceReportInfo,
                let device = response.device,
                
                    let data = response.data as? YCReceivedMonitoringModeInfo
        {
            self.textView.text =
                (device.name ?? "") + "\n" +
                data.toString
        }
        
    }
    
}

extension YCAppControlViewController {
    
    private func exampleForItems(_ index: Int) {
        
        self.textView.text = ""
        
        switch index {
        case 0:
            
            YCProduct.findDevice { state, response in
                
                self.showState(state)
            }
            
        case 1: // 血压校准
            YCProduct.deviceBloodPressureCalibration(systolicBloodPressure: 110, diastolicBloodPressure: 72) { state, response in
                
                self.showState(state)
            }
            
            
        case 2:
            YCProduct.deviceTemperatureCalibration { state, _ in
                self.showState(state)
            }
            
        case 3:
            YCProduct.deviceArmpitTemperatureMeasurement(isEnable: true) { state, _ in
                self.showState(state)
            }
            
            Thread.sleep(forTimeInterval: 3.0)
            
            YCProduct.queryDeviceRealTimeTemperature { state, response in
                
                if state == .succeed,
                   let temperature = response as? Double {
                    
                    self.textView.text = "\(temperature)"
                } else {
                    self.showState(state)
                }
            }
            
            YCProduct.deviceArmpitTemperatureMeasurement(isEnable: false) { state, _ in
                
                self.showState(state)
            }
            
        case 4: // qrcode color
            YCProduct.changeDeviceBodyTemperatureQRCodeColor(color: .green) { state, _ in
                
                self.showState(state)
            }
            
        case 5:  // 天气
            YCProduct.sendWeatherData(lowestTemperature: -20, highestTemperature: 36, realTimeTemperature: 25, weatherType: .sunny, windDirection: nil, windPower: nil, location: nil, moonType: nil) { state, _ in
                
                self.showState(state)
            }
            
        case 6:
            YCProduct.deviceSystemOperator(mode: .shutDown) { state, _ in
                
                self.showState(state)
            }
            
        case 7:
            YCProduct.realTimeDataUplod(isEnable: true, dataType: YCRealTimeDataType.step) { state, response in
                
                self.showState(state)
            }
            
        case 8:
            YCProduct.waveDataUpload(state: .uploadWithOutSerialnumber, dataType: .ppg) { state, _ in
                
                self.showState(state)
            }
            
        case 9: // 健康数据测量
            YCProduct.controlMeasureHealthData(measureType: .single, dataType: .heartRate) { state, response in
                self.showState(state)
            }
            
            //            YCProduct.controlMeasureHealthData(measureType: .off, dataType: .heartRate) { state, response in
            //                if state == .succeed {
            //                    print("success")
            //                } else {
            //                    print("fail")
            //                }
            //            }
            
        case 10:
            
            YCProduct.controlSport(
                state: .start,
                sportType: .run) { state, response in
                    self.showState(state)
                }
            
        case 11:
            YCProduct.controlSport(state: .stop, sportType: .run) { state, response in
                self.showState(state)
            }
            
        case 12: 
            state = !state
            YCProduct.takephotoByPhone(isEnable: state) { state, response in
                
                self.showState(state)
            }
            
            // 退出拍照
             
        case 13: // 预警信息
            YCProduct.sendHealthParameters(warningState: .off, healthState: .good, healthIndex: 100, othersWarningState: .off) { state, response in
                self.showState(state)
            }
            
        case 14: // 亲友消息显示
            YCProduct.deviceShowFriendMessage(index: 1, hour: 10, minute: 23, name: "俺是大宝二") { state, response in
                self.showState(state)
            }
            
        case 15:
            YCProduct.deviceHealthValueWriteBack(healthValue: 50, statusDescription: "非常好") { state, response in
                self.showState(state)
            }
            
        case 16:
            YCProduct.deviceSleepDataWriteBack(deepSleepHour: 2, deepSleepMinute: 30, lightSleepHour: 4, lightSleepMinute: 0, totalSleepHour: 8, totalSleepMinute: 0) { state, response in
                self.showState(state)
            }
            
        case 17:
            YCProduct.devicePersonalInfoWriteBack(infoType: .vip, information: "VIP") { state, response in
                self.showState(state)
            }
            
        case 18:
            YCProduct.deviceUpgradeReminderWriteBack(isEnable: true, percentage: 60) { state, response in
                self.showState(state)
            }
            
        case 19:
            YCProduct.deviceSportDataWriteBack(step: 10000, state: .reduceFatShape) { state, response in
                self.showState(state)
            }
            
        case 20:
            YCProduct.sendCaclulateHeartRate(heartRate: 78) { state, response in
                self.showState(state)
            }
            
        case 21:
            YCProduct.deviceMeasurementDataWriteBack(dataType: .bloodPressure, values: [110, 220]) { state, response in
                self.showState(state)
            }
            
        case 22:
            YCProduct.deviceSenserSaveData(dataType: .temperatureHumidity, isEable: false) { state, response in
                self.showState(state)
            }
            
        case 23: // 手机型号
            YCProduct.sendPhoneModeInfo(mode: "iPhone13 Pro Max") { state, response in
                self.showState(state)
            }
            
        case 24:
            YCProduct.sendWarningInformation(infoType: .warnSelf, message: nil) { state, response in
                self.showState(state)
            }
            
        case 25:
            YCProduct.sendShowMessage(index: 1, content: nil) { state, response in
                self.showState(state)
            }
            
        case 26:
            YCProduct.deviceTemperatureHumidityCalibration(temperaturerInteger: 36, temperaturerDecimal: 5, humidityInteger: 43, humidityDecimal: 4) { state, response in
                self.showState(state)
            }
            
        case 27:
            YCProduct.startSendAddressBook { state, response in
                
                self.showState(state)
            }
            
            YCProduct.sendAddressBook(phone: "13800138000", name: "jack") { state, response in
                self.showState(state)
            }
            
            YCProduct.stopSendAddressBook { state, response in
                
                self.showState(state)
            }
                        
            
        default:
            break
        }
    }
    
    /// 显示状态
    private func showState(_ state: YCProductState) {
        
        if state == .succeed {
            MBProgressHUD.wj_showSuccess(nil)
        } else if state == .unavailable {
            self.textView.text = "Not support"
        } else if state == .noRecord {
            self.textView.text = "No data"
        } else if state == .failed {
            MBProgressHUD.wj_showError()
        }
    }
}

extension YCAppControlViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        exampleForItems(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 0,
           YCProduct.shared.currentPeripheral?.supportItems.isSupportFindDevice != true {
        
            return 0
            
        } else if indexPath.row == 1,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodPressureCalibration != true {
            
            return 0
            
        } else if indexPath.row == 2,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportTemperatureCalibration != true {
            
            return 0
            
        } else if indexPath.row == 3,
        
                    YCProduct.shared.currentPeripheral?.supportItems.isSupportAxillaryTemperatureMeasurement != true {
            
            return 0
            
        } else if indexPath.row == 4 {
            
            return 0
            
        } else if indexPath.row == 9,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportStartHeartRateMeasurement != true {
            
            return 0
        
        } else if indexPath.row >= 13 && indexPath.row <= 26 {
            
            return 0
            
        } else if indexPath.row == 27,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportAddressBook != true {
            
            return 0
        }
        
        return 49
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableView.self), for: indexPath)
        
        cell.textLabel?.text = // "\(indexPath.row + 1). " +
            items[indexPath.row]
        
        if indexPath.row  == 0 {
        
            cell.isHidden =
            YCProduct.shared.currentPeripheral?.supportItems.isSupportFindDevice != true
            
        } else if indexPath.row == 1 {
            
            cell.isHidden =
            YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodPressureCalibration != true
            
        } else if indexPath.row == 2 {
            
            cell.isHidden =
            YCProduct.shared.currentPeripheral?.supportItems.isSupportTemperatureCalibration != true
            
        } else if indexPath.row == 3 {
            
            cell.isHidden =
            YCProduct.shared.currentPeripheral?.supportItems.isSupportAxillaryTemperatureMeasurement != true
            
        } else if indexPath.row == 4 {
            
            cell.isHidden = true
        } else if indexPath.row == 9 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportStartHeartRateMeasurement != true
            
        } else if indexPath.row >= 13 && indexPath.row <= 26 {
            cell.isHidden = true
        } else if indexPath.row == 27 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportAddressBook != true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
