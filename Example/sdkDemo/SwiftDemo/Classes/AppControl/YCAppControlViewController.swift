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
        "location",
        "send health data",
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
        if let response = info[YCDeviceControlType.photo.toString] as? YCReceivedDeviceReportInfo,
           let device = response.device,
           let state = response.data as? YCDeviceControlPhotoState {
            print(device.name ?? "",
                  state
            )
            
            self.textView.text = "photo: \(state.toString)"
        }
        
        // 找手机
        if let response = info[YCDeviceControlType.findPhone.toString] as? YCReceivedDeviceReportInfo,
           let device = response.device,
           let state = response.data as? YCDeviceControlState {
            
            self.textView.text = (device.name ?? "") + "find phone state: \(state.toString)"
        }
        
        // sos
        if let response = info[YCDeviceControlType.sos.toString] as? YCReceivedDeviceReportInfo,
           let device = response.device {
            
            self.textView.text = (device.name ?? "") + "sos"
        }
        
        // 是否允许连接
        if let response = info[YCDeviceControlType.allowConnection.toString] as? YCReceivedDeviceReportInfo,
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
            
            // 查找设备，设备会震动
            // Find the device, the device will vibrate
            YCProduct.findDevice { state, response in
                
                self.showState(state)
            }
            
        case 1:
            // 校准光电血压 收缩压110, 舒张压72
            // Calibrated photoelectric blood pressure 110 systolic, 72 diastolic
            ///   - systolicBloodPressure: Systolic blood pressure
            ///   - diastolicBloodPressure: Diastolic blood pressure
            YCProduct.deviceBloodPressureCalibration(systolicBloodPressure: 110, diastolicBloodPressure: 72) { state, response in
                
                self.showState(state)
            }
            
            
        case 2:
            
            // 温度校准，用于工厂生产，App开发不需要
            // Temperature calibration for factory production, not required for app development
            YCProduct.deviceTemperatureCalibration { state, _ in
                self.showState(state)
            }
            
        case 3:
            
            // 启动腋下温度测量，启动后需要不断重复读取设备实时温度
            // Start the armpit temperature measurement, after starting, you need to repeatedly read the real-time temperature of the device
            YCProduct.deviceArmpitTemperatureMeasurement(isEnable: true) { state, _ in
                self.showState(state)
            }
            
            Thread.sleep(forTimeInterval: 3.0)
            
            // 读取腋下温度，这个动作要不断重复.
            // Read the armpit temperature, this action should be repeated.
            YCProduct.queryDeviceRealTimeTemperature { state, response in
                
                if state == .succeed,
                   let temperature = response as? Double {
                    
                    self.textView.text = "\(temperature)"
                } else {
                    self.showState(state)
                }
            }
            
            // 关闭腋下温度测量，整个测量时间建议10分钟.
            // Turn off the armpit temperature measurement, the whole measurement time is recommended to be 10 minutes.
            YCProduct.deviceArmpitTemperatureMeasurement(isEnable: false) { state, _ in
                
                self.showState(state)
            }
            
        case 4: // qrcode color
            
            /**
             
             @objc public enum YCBodyTemperatureQRCodeColor: UInt8 {
                case green
                case red
                case orange
             }
             
             */
            
            // 变换体温二维码的颜色,  一般设备没有此功能
            // Change the color of the body temperature QR code, general equipment does not have this function
            ///   - color: color
            YCProduct.changeDeviceBodyTemperatureQRCodeColor(color: .green) { state, _ in
                
                self.showState(state)
            }
            
        case 5:  // 天气
            
            /**
             /// Weather code type
             @objc public enum YCWeatherCodeType: UInt8 {
                 case unknow
                 case sunny
                 case cloudy
                 case wind
                 case rain
                 case snow
                 case foggy
             }
             
             */
            
            // 发送今天天气数据, 范围 -20 ~ 36, 当前温度25摄氏度, 晴天, 其它参数只有个别设备支持，
            // Send today's weather data, range -20 ~ 36, current temperature 25 degrees Celsius, sunny, other parameters are only supported by individual devices,
            ///   - isTomorrow: Today's weather or tomorrow's weather
            ///   - lowestTemperature: Minimum temperature Celsius
            ///   - highestTemperature: Maximum temperature Celsius
            ///   - realTimeTemperature: Current weather temperature Celsius
            ///   - weatherType: YCWeatherCodeType
            ///   - windDirection: Wind direction
            ///   - windPower: Wind force
            ///   - location: City
            ///   - moonType: Moon phase
            YCProduct.sendWeatherData(lowestTemperature: -20, highestTemperature: 36, realTimeTemperature: 25, weatherType: .rain, windDirection: nil, windPower: nil, location: nil, moonType: nil) { state, _ in
                
                self.showState(state)
            }
            
        case 6:
            
            /**
             
             /// device mode
             @objc public enum YCDeviceSystemOperator: UInt8 {
                 case shutDown       = 1
                 case transportation
                 case resetRestart
             }
             */
            
            // 关机
            // shutdown
            ///   - mode: Shutdown reset restart
            YCProduct.deviceSystemOperator(mode: .shutDown) { state, _ in
                
                self.showState(state)
            }
            
        case 7:
            
            /**
             /// type of data
             @objc public enum YCRealTimeDataType: UInt8 {
                 case step
                 case heartRate
                case bloodOxygen
                 case bloodPressure
             }
             
             */
            
            // 开启实时步数上传, 开启成功后要监测对应的通知.
            // Turn on real-time step upload, and monitor the corresponding notification after it is turned on successfully.
            
            ///   - isEnable: Whether to open or close
            ///   - dataType: YCRealTimeDataType
            ///   - interval: 1 ~ 240 seconds, it is recommended to use the default value of 2 seconds
            YCProduct.realTimeDataUplod(isEnable: true, dataType: YCRealTimeDataType.step) { state, response in
                
                self.showState(state)
            }
            
        case 8:
            
            /**
             
             /// Waveform type selection
             @objc public enum YCWaveDataType: UInt8 {
                 case ppg
                 case ecg
                 case multiAxisSensor
                 case ambientLight
             }

               @objc public enum YCWaveUploadState: UInt8 {
                   case off = 0     // Stop transfer
                   case uploadWithOutSerialnumber                  // No serial number transmission
                   case uploadSerialnumber                    // With 8-digit charge number transmission
               }
             
             */
            
            // 注意: 只有个别设备支持直接调用，其它情况不需要使用，SDK内部会使用
            
            // 开启ppg波形数据上传, 开启成功后要监测对应的通知.
            // Turn on ppg waveform data upload, and monitor the corresponding notification after it is turned on successfully.
            ///   - state: YCWaveUploadState
            ///   - dataType: YCWaveDataType
            YCProduct.waveDataUpload(state: .uploadWithOutSerialnumber, dataType: .ppg) { state, _ in
                
                self.showState(state)
            }
            
        case 9: // 健康数据测量
            
            /**
             
             /// Measurement method
             @objc public enum YCAppControlHealthDataMeasureType: UInt8 {
                 case off        // Close measurement
                 case single     // Single measurement
                 case monitor    // Reserved parameters
             }
             
             // type of data
             @objc public enum YCAppControlMeasureHealthDataType: UInt8 {
                 case heartRate
                 case bloodPressure
                 case bloodOxygen
                 case respirationRate
                 case bodyTemperature
                 case unknow
             }
             
             */
            
            // 启动手表的心率测量，启动成功后，手表会进度测量心率界面。
            // Start the heart rate measurement of the watch. After the start is successful, the watch will progress to the heart rate measurement interface.
            ///   - measureType: YCAppControlHealthDataMeasureType
            ///   - dataType: YCAppControlMeasureHealthDataType
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
            
            /**
             @objc public enum YCDeviceSportState: UInt8 {
                 case stop
                 case start
              }
             */
            
            // 开启跑步
            // start running
            ///   - state: YCDeviceSportState
            ///   - sportType: YCDeviceSportType
            YCProduct.controlSport(
                state: .start,
                sportType: .run) { state, response in
                    self.showState(state)
                }
            
        case 11:
            
            // 结束跑步
            // end the run
            ///   - state: YCDeviceSportState
            ///   - sportType: YCDeviceSportType
            YCProduct.controlSport(state: .stop, sportType: .run) { state, response in
                self.showState(state)
            }
            
        case 12:
            
            // 启动或退出设备进入拍照模式
            // Start or exit the device into camera mode
            ///   - isEnable: Activate or deactivate photo mode
            state = !state
            YCProduct.takephotoByPhone(isEnable: state) { state, response in
                
                self.showState(state)
            }
            
        case 13: // 预警信息
            
            /**
             
             /// Warning status
             @objc public enum YCHealthParametersState: UInt8 {
                 case off
                 case effect
                 case invalid
             }
             
             /// health status
             @objc public enum YCHealthState: UInt8 {
                 case unknow
                 case excellent
                 case good
                 case general
                 case poor
                 case sick
                 case invalid
             }
             
             */
            
            // 向设备发送健康状态信息
            // Send health information to devices
            ///   - warningState: YCHealthParametersState
            ///   - healthState: YCHealthState
            ///   - healthIndex: 0 ~ 120
            ///   - othersWarningState: Is the warning for relatives and friends effective?
            YCProduct.sendHealthParameters(
                warningState: .off,
                healthState: .good,
                healthIndex: 100,
                othersWarningState: .off) { state, response in
                    self.showState(state)
                }
            
        case 14: // 亲友消息显示
            
            // 发送亲友信息, 个别设备支持
            // Send friends and relatives information, individual device support
            /// - index: Emoticon number 0 ~ 4
            /// -hour: Send time 0~23
            /// - minute: Send time 0 ~ 59
            /// - name: Name of relatives and friends
            YCProduct.deviceShowFriendMessage(
                index: 1,
                hour: 10,
                minute: 23,
                name: "俺是大宝二") { state, response in
                    self.showState(state)
                }
            
        case 15:
            
            // 回写健康数据，个别设备才支持
            // Write back health data, only supported by individual devices
            ///   - healthValue: Health value
            ///   - statusDescription: Description
            YCProduct.deviceHealthValueWriteBack(healthValue: 50, statusDescription: "非常好") { state, response in
                self.showState(state)
            }
            
        case 16:
            
            // 回写睡眠数据，个别设备才支持
            // Write back sleep data, only supported by individual devices
            ///   - deepSleepHour: 0 ~ 23
            ///   - deepSleepMinute:   0 ~ 23
            ///   - lightSleepHour: 0 ~ 23
            ///   - lightSleepMinute: 0 ~ 59
            ///   - totalSleepHour: 0 ~ 23
            ///   - totalSleepMinute: 0 ~ 59
            YCProduct.deviceSleepDataWriteBack(deepSleepHour: 2, deepSleepMinute: 30, lightSleepHour: 4, lightSleepMinute: 0, totalSleepHour: 8, totalSleepMinute: 0) { state, response in
                self.showState(state)
            }
            
        case 17:
            
            /**
             
             /// Personal type
             @objc public enum YCPersonalInfoType: UInt8 {
                 case insurance
                case vip
             
             }
             */
            
            // 个人数据回写，个别设备才支持
            // Personal data write-back, only supported by individual devices
            ///   - infoType: User information type
            ///   - information: Description
            YCProduct.devicePersonalInfoWriteBack(infoType: .vip, information: "VIP") { state, response in
                self.showState(state)
            }
            
        case 18:
            
            // 升级进度回写，个别设备才支持
            // Upgrade progress write-back, only supported by individual devices
            ///   - isEnable: Whether to enable reminder
            ///   - percentage: Current progress 0 ~ 100
            YCProduct.deviceUpgradeReminderWriteBack(isEnable: true, percentage: 60) { state, response in
                self.showState(state)
            }
            
        case 19:
            
            // 运动数据回写，个别设备才支持
            // Sports data write-back, only supported by individual devices
            ///   - step: Exercise steps
            ///   - state: Sport state
            YCProduct.deviceSportDataWriteBack(step: 10000, state: .reduceFatShape) { state, response in
                self.showState(state)
            }
            
        case 20:
            
            // 发送计算心率，个别设备才支持
            // Send calculated heart rate, only supported by individual devices
            ///   - heartRate:  Calculate heart rate
            YCProduct.sendCaclulateHeartRate(heartRate: 78) { state, response in
                self.showState(state)
            }
            
        case 21:
            
            // 测量数据回写，个别设备才支持
            // Measurement data write-back, only supported by individual devices
            ///   - dataType: Measurement data type
            ///   - values: Measured value collection
            YCProduct.deviceMeasurementDataWriteBack(dataType: .bloodPressure, values: [110, 220]) { state, response in
                self.showState(state)
            }
            
        case 22:
            
            /**
             
             /// Sensor type
             @objc public enum YCDeviceSenserSaveDataType: UInt8 {
                 case ppg    = 0
                 case acceleration
                 case ecg
                 case temperatureHumidity
                 case ambientLight
                 case bodyTemperature
             }
             */
            // 设备传感器数据保存是否开启，个别设备才支持
            // Whether the device sensor data saving is enabled, only supported by individual devices
            ///   - dataType: Sensor type
            ///   - isEable: Whether to open
            YCProduct.deviceSenserSaveData(dataType: .temperatureHumidity, isEable: false) { state, response in
                self.showState(state)
            }
            
        case 23: // 手机型号
            
            // 发送手机型号，个别设备才支持
            // Send the mobile phone model, only individual devices are supported
            ///   - mode: Phone model such as iPhone 13
            YCProduct.sendPhoneModeInfo(mode: "iPhone13 Pro Max") { state, response in
                self.showState(state)
            }
            
        case 24:
            
            /**
             
             /// Warning message type
             @objc public enum YCWarningInformationType: UInt8 {
             
             case warnSelf  // Alert yourself
             case warnOthers // Alert others
             case highRisk // High risk of exercise
             case nonHighRisk // Non-high risk
             
             }
             */
            // 发送预警信息，个别设备才支持
            // Sending early warning information only supported by individual devices
            ///   - infoType: YCWarningInformationType
            ///   - message: information
            YCProduct.sendWarningInformation(infoType: .warnSelf, message: nil) { state, response in
                self.showState(state)
            }
            
        case 25:
            
            // 发送展示信息，个别设备才支持
            // Send display information, only supported by individual devices
            ///   - index: Information label 0 ~ 6
            ///   - content: information
            YCProduct.sendShowMessage(index: 1, content: nil) { state, response in
                self.showState(state)
            }
            
        case 26:
            
            // 校准温温度，个别设备才支持
            // Calibration temperature, only supported by individual devices
            ///   - temperaturerInteger: Temperature integer
            ///   - temperaturerDecimal: Temperature decimal
            ///   - humidityInteger: Humidity integer
            ///   - humidityDecimal: Humidity decimal
            YCProduct.deviceTemperatureHumidityCalibration(temperaturerInteger: 36, temperaturerDecimal: 5, humidityInteger: 43, humidityDecimal: 4) { state, response in
                self.showState(state)
            }
            
        case 27:
            
            // 开启发送通讯录信息
            // Enable sending address book information
            YCProduct.startSendAddressBook { state, response in
                
                self.showState(state)
            }
            
            // 发送通讯录具体数据
            // Send address book specific data
            ///   - phone: Phone number, no more than 20 characters
            ///   - name: Username, no more than 8 Chinese
            YCProduct.sendAddressBook(phone: "13800138000", name: "jack") { state, response in
                self.showState(state)
            }
            
            // 结束发送通讯录信息
            // End sending address book information
            YCProduct.stopSendAddressBook { state, response in
                
                self.showState(state)
            }
            
        case 28: // 定位信息
            YCProduct.sendLocationInformation(locationType: .detailedAddress, content: "深圳市宝安区西乡街道铁仔路50号风凰智谷") { state, response in
                
                self.showState(state)
            }
            
        case 29:
            
            let time = UInt(Date().timeIntervalSince1970)
            
            let intValue = Int8(arc4random() % (12 - 2 + 1) + 2)
            let decValue = Int8(intValue + 2 % 10)
            
            YCProduct.sendMeasuredHealthData(
                dataType: .bloodGlucose,
                time: time,
                values: [intValue, decValue]
            ) { state, response in
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
