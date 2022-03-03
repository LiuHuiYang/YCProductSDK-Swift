//
//  YCSettingViewController.swift
//  SwiftDemo
//
//  Created by macos on 2021/12/6.
//

import UIKit
import YCProductSDK
//import MBProgressHUD_WJExtension

class YCSettingViewController: UIViewController {
    
    private lazy var items = [
        "time",
        "step goal",
        "calories goal",
        "distance goal",
        "sleep goal",
        "sport time goal",
        "effective step goal",
        
        "user info",
        "unit",
        "sedentar",
        "antiLost",
        "info push",
        "heart rate alarm",
        "heart rate monitoring",
        "not disturb",
        "reset",
        "language",
        "wrist bright screen",
        "brightness",
        "skin color",
        "blood pressure level",
        "device name",
        "sensor sample Rate",
        "theme",
        "sleep reminder",
        "data collection",
        "blood pressure monitoring",
        "temperature alarm",
        "temperature monitoring",
        "breath screen",
        "ambient light monitoring",
        "work mode",
        "accident monitoring",
        "reminder type",
        "bloodOxygen monitoring",
        "temperature humidity monitoring",
        "upload reminder",
        "pedometer time",
        "broadcast interval",
        "transmit power",
        "heart rate zone",
        "show insurance",
        "data collection setting for work mode",
        "bp alarm",
        "sp02 alarm",
        "motor vibration",
        
        "query alarm",
        "add alarm",
        "delete alarm",
        "modify alarm",
        
        "event enable",
        "add event",
        "delete event",
        "modify event",
        "query event",
    ]
    
    @IBOutlet weak var listView: UITableView!
    
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Setting"
        listView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableView.self))
    }

}

extension YCSettingViewController {
    
    private func exampleForItems(_ index: Int) {
        
        self.textView.text = ""
        
        switch index {
        case 0:
            
            /**
                
             @objc public enum YCWeekDay : UInt8 {
                 case monday
                 case tuesday
                 case wednesday
                 case thursday
                 case friday
                 case saturday
                 case sunday
             }
             
             */
            // 设置时间
            // time setting
            ///   - year:  2000+
            /// -month:1~12
            /// -day: 1~31
            /// -hour: 0~23
            /// -minute: 0~59
            /// -second: 0~59
            /// - weekDay: YCWeekDay
            YCProduct.setDeviceTime(
                year: 2021,
                month: 12,
                day: 6,
                hour: 14,
                minute: 38,
                second: 59,
                weekDay: .monday) { state, response in
                
                    self.showState(state)
            }
            
        case 1: // step
            
            // 步数目标
            // step goal
            ///   - step: Step goal (steps)
            YCProduct.setDeviceStepGoal(
                step: 10000) { state, _ in
                
                    self.showState(state)
            }
            
        case 2:  // Calories
            
            // 卡路里目标，个别设备支持
            // Calorie goals, individual device support
            ///   - calories: Calorie goal (kcal)
            YCProduct.setDeviceCaloriesGoal(calories: 1000) { state, _ in
                
                self.showState(state)
            }
            
        case 3: // Distance
            
            // 距离目标，个别设备支持
            // Distance target, individual device support
            ///   - calories: Distance target (m)
            YCProduct.setDeviceDistanceGoal(distance: 10000) { state, _ in
                
                self.showState(state)
            }
            
        case 4: // Sleep
            
            // 睡眠目标
            // sleep goals
            /// -hour:0~23
            /// -minute:0~59
            YCProduct.setDeviceSleepGoal(hour: 8, minute: 30) { state, response in
                
                self.showState(state)
            }
            
        case 5: // sport time
            
            // 运动时间目标，个别设备才支持
            // Exercise time target, only supported by individual devices.
            /// -hour:0~23
            /// -minute:0~59
            YCProduct.setDeviceSportTimeGoal(hour: 1, minute: 20) { state, response in
                self.showState(state)
            }
            
        case 6: // EffectiveStep
            
            // 有效步数目标，个别设备才支持
            // Valid step target, only supported by individual devices.
            ///   - effectiveSteps: Effective step goal (steps)
            YCProduct.setDeviceEffectiveStepsGoal(effectiveSteps: 8000) { state, response in
                
                self.showState(state)
            }
            
        case 7: // user info
            
            /**
             
             /// Gender
             @objc public enum YCDeviceGender: UInt8 {
                 case male
                 case female
             }
             */
            // 设置用户的身高，体重，性别，年龄
            // Set the user's height, weight, gender, age
            ///   - height:  100 ~ 250cm
            ///   - weight:  30 ~ 200 kg
            ///   - gender:  YCDeviceGender
            ///   -age: 6~120
            YCProduct.setDeviceUserInfo(height: 180, weight: 90, gender: .male, age: 18) { state, response in
                self.showState(state)
            }
            
        case 8: // unit
            
            /**
             
             /// Distance unit
             @objc public enum YCDeviceDistanceType: UInt8 {
                 case km
                 case mile
             }
             
             /// Weight unit
             @objc public enum YCDeviceWeightType: UInt8 {
                 case kg
                 case lb
             }
             
             /// Temperature unit
             @objc public enum YCDeviceTemperatureType: UInt8 {
                 case celsius
                 case fahrenheit
             }
             
             /// Time format
             @objc public enum YCDeviceTimeType: UInt8 {
                case hour24
                case hour12
             }
             
             */
            
            // 设置手表的单位
            // Set the unit of the watch
            ///   - distance: Distance unit
            ///   - weight: Weight unit
            ///   - temperature: Temperature unit
            ///   - timeFormat: Time format: 12-hour clock/24-hour clock
            YCProduct.setDeviceUnit(distance: .km, weight: .kg, temperature: .celsius, timeFormat: .hour24) { state, response in
                
                self.showState(state)
            }
            
        case 9: // Sedentary
            
            /**
             
             /// Repeat time of the week
             @objc public enum YCDeviceWeekRepeat: UInt8 {
                 case monday
                 case tuesday
                 case wednesday
                 case thursday
                 case friday
                 case saturday
                 case sunday
                 case enable
             }
             
             */
            
            // 设置久坐提醒
            // Set a sedentary reminder
            ///   - startHour1:  0 ~ 23
            ///   - startMinute1:  0 ~ 59
            ///   - endHour1:  0 ~ 23
            ///   - endMinute1:  0 ~ 59
            ///   - startHour2: 0 ~ 23
            ///   - startMinute2:  0 ~ 59
            ///   - endHour2: 0 ~ 23
            ///   - endMinute2:   0 ~ 59
            ///   - interval: 15 ~ 45 minutes
            ///   - repeat:   YCDeviceWeekRepeat
            YCProduct.setDeviceSedentary(
                startHour1: 9,
                startMinute1: 0,
                endHour1: 12,
                endMinute1: 30,
                startHour2: 13,
                startMinute2: 30,
                endHour2: 18,
                endMinute2: 00,
                interval: 15,
                repeat: [
                .monday, .tuesday, .wednesday, .thursday, .friday, .enable]
            ) { state, response in
                    
                    self.showState(state)
                }
            
        case 10:
            
            // 开启防丢功能
            // Enable anti-lost function
            ///   - antiLostType: Anti-lost type
            YCProduct.setDeviceAntiLost(antiLostType: .middleDistance) { state, response in
                self.showState(state)
            }
        
            
        case 11:  // info push
            
            /**
             ///  Notification reminder type
             @objc public enum YCDeviceInfoPushType: UInt16 {
                case call
                case sms
                case email
                case wechat
                case qq
                case weibo
                case facebook
                case twitter
                    
                case messenger
                case whatsAPP
                case linkedIn
                case instagram
                case skype
                case line
                case snapchat
                case telegram
              
                case other
                case viber
             }
             
             */
            
            // 设置消息推送类型
            // Set message push type
            ///   - isEnable: Whether to open
            ///   - infoPushType: Notification reminder type
            YCProduct.setDeviceInfoPush(isEnable: true, infoPushType: [.qq, .twitter, .call]) { state, response in
                
            }
            
//            YCProduct.setDeviceInfoPush(isEnable: false, infoPushType: [.qq, .twitter, .call]) { state, response in
//                
//            }
    
            
        case 12: // hr alarm
            
            // 设置心率告警
            // Set heart rate alerts
            ///   - isEnable: Whether to open
            ///   - maxHeartRate: Heart rate warning upper limit 100 ~ 240
            ///   - minHeartRate: Heart rate lower limit 30 ~ 60
            YCProduct.setDeviceHeartRateAlarm(isEnable: true, maxHeartRate: 100, minHeartRate: 50) { state, response in
                self.showState(state)
            }
            
        case 13: // HeartRate Monitoring
            
            // 自动心率监测 包含心率，血压，呼吸率，血氧
            // Automatic heart rate monitoring including heart rate, blood pressure, respiratory rate, blood oxygen
            
            ///   - isEnable: Whether to enable
            ///   - interval: Monitoring interval 1 ~ 60 minutes
            YCProduct.setDeviceHeartRateMonitoringMode(isEnable: true, interval: 60) { state, response in
                self.showState(state)
            }
            
        case 14: // not disturb
            
            // 设置勿扰时间
            // Set Do Not Disturb time
            ///   - isEable: Whether to enable
            ///   - startHour: 0 ~ 23
            ///   - startMinute: 0 ~ 59
            ///   - endHour: 0 ~ 23
            ///   - endMinute: 0 ~ 59
            YCProduct.setDeviceNotDisturb(isEable: true, startHour: 9, startMinute: 30, endHour: 12, endMinute: 0) { state, response in
                self.showState(state)
            }
            
        case 15:
            
            // 复位
            // reset
            YCProduct.setDeviceReset { state, response in
                self.showState(state)
            }
            
        case 16:
            
            /**
             /// language
             @objc public enum YCDeviceLanguageType: UInt8 {
                 case english
                 case chineseSimplified
                 case russian
                 case german
                 case french
                 case japanese
                 case spanish
                 case italian
                 case portuguese
                 case korean
                 case poland
                 case malay
                 case chineseTradition
                 case thai
                 case vietnamese
                 case hungarian
                 case arabic
                 case greek
                 case malaysian
                 case hebrew
                 case finnish
                 case czech
                 case croatian
                 case persian
                 case ukrainian
                 case turkish
                 case danish
                 case swedish
                 case norwegian
                 case romanian
             }
             
             */
            
            // 设置设备语言
            // Set device language
            YCProduct.setDeviceLanguage(language: .persian) { state, response in
                self.showState(state)
            }
            
        case 17: // WristBrightScree
            
            // 开启抬腕亮屏
            // Turn on wrist lift
            YCProduct.setDeviceWristBrightScreen(isEnable: true) { state, response in
                self.showState(state)
            }
            
        case 18: // Brightness
            
            /**
            
             /// Brightness level
             @objc public enum YCDeviceDisplayBrightnessLevel : UInt8 {
                 case low
                 case middle
                 case high
             
             // 下面的三个取值只是个别设备支持
             // The following three values are only supported by individual devices
             
                 case automatic
                 case lower
                 case higher
             
             }
             
             */
            
            // 设置屏幕亮度
            // Set screen brightness
            YCProduct.setDeviceDisplayBrightness(level: .middle) { state, response in
                self.showState(state)
            }
            
        case 19: // skin color
            
            /**
             
             @objc public enum YCDeviceSkinColorLevel: UInt8 {
               case white
               case whiteYellow
               case yellow
               case brown
               case darkBrown
               case black
               case other
             }
             
             */
            
            // 设置皮肤颜色
            // set skin color
            YCProduct.setDeviceSkinColor(level: .yellow) { state, response in
                self.showState(state)
            }
            
        case 20: // blood pressure level
            
            /**
             
             /// Blood pressure level
             @objc public enum YCDeviceBloodPressureLevel: UInt8 {
                 case low
                 case normal
                 case slightlyHigh
                 case moderatelyHigh
                 case severeHigh
             }
             */
            
            // 设置血压等级, 如果设备支持血压校准，不需要使用这个API。
            // Set blood pressure level,If the device supports blood pressure calibration, you do not need to use this API.
            YCProduct.setDeviceBloodPressureRange(level: .normal) { state, response in
                self.showState(state)
            }
            
        case 21: // device name
            
            // 修改设备显示名称, 生产使用，App不需要使用
            // Modify the device display name, production use, App does not need to use
            YCProduct.setDeviceName(name: "YC2022") { state, response in
                self.showState(state)
            }
            
        case 22: // sensor sample Rate
            
            // 设置传感器采样率，App开发不要随意去设置，此功能仅部分设备支持
            // Set the sensor sampling rate. Do not arbitrarily set the app development. This function is only supported by some devices.
            ///   - ppg: PPG sampling rate HZ
            ///   - ecg: ECG sampling rate HZ
            ///   - gSensor: G-Sensor sampling rate HZ
            ///   - tempeatureSensor: Temperature sensor sampling rate HZ
            YCProduct.setDeviceSensorSamplingRate(ppg: 250, ecg: 100, gSensor: 25, tempeatureSensor: 10) { state, response in
                self.showState(state)
            }
            
        case 23: // theme
            
            // 设置当前显示主题
            // Set the current display theme
            ///   - index: Theme Index
            YCProduct.setDeviceTheme(index: 0) { state, response in
                self.showState(state)
            }
            
        case 24: // 睡眠提醒时间
            
            // 设置睡眠提醒，个别设备才支持
            // Set sleep reminders, only supported by individual devices
            /// -hour:0~23
            ///   - minute: 0 ~ 59
            ///   - repeat: YCDeviceWeekRepeat
            YCProduct.setDeviceSleepReminder(hour: 22, minute: 30, repeat: [.monday, .thursday, .wednesday, .enable]) { state, response in
                self.showState(state)
            }
            
        case 25:
            
            // 设置数据采集时间，仅个别设备支持此功能
            // Set the data collection time, only some devices support this function
            YCProduct.setDeviceDataCollection(isEnable: true, dataType: .ppg, acquisitionTime: 90, acquisitionInterval: 60) { state, response in
                self.showState(state)
            }
            
        case 26: // BloodPressureMonitoring
            
            // 血压监测，已不需要使用此API.
            // Blood pressure monitoring, no need to use this API.
            YCProduct.setDeviceBloodPressureMonitoringMode(isEnable: true, interval: 60) { state, response in
                self.showState(state)
            }
            
        case 27: // temperature alarm
            
            // 温度预警
            // temperature warning
            ///   - isEnable: Whether to open
            ///   - highTemperatureIntegerValue: 36 ~ 100 Celsius
            ///   - highTemperatureDecimalValue: 0 ~ 9 Celsius
            ///   - lowTemperatureIntegerValue: -127 ~ 36 Celsius
            ///   - lowTemperatureDecimalValue: 0 ~ 9 Celsius
            YCProduct.setDeviceTemperatureAlarm(isEnable: true, highTemperatureIntegerValue: 37, highTemperatureDecimalValue: 3, lowTemperatureIntegerValue: 35, lowTemperatureDecimalValue: 5) { state, response in
                self.showState(state)
            }
            
        case 28: // temperature monitoring
            
            // 温度自动监测
            // Automatic temperature monitoring
            ///   - isEnable: Whether to open
            ///   - interval: Monitoring interval 1 ~ 60 minutes
            YCProduct.setDeviceTemperatureMonitoringMode(isEnable: true, interval: 60) { state, response in
                self.showState(state)
            }
            
        case 29: // 息屏时间
            
            /**
             
             @objc public enum YCDeviceBreathScreenInterval: UInt8 {
                 case five       // 5s
                 case ten        // 10s
                 case fifteen    // 15s
                 case thirty     // 30s
             }
             
             */
            
            // 设置息屏时间，只有个别设备才支持
            // Set the screen time, only supported by individual devices
            ///   - interval: YCDeviceBreathScreenInterval
            YCProduct.setDeviceBreathScreen(interval: .fifteen) { state, response in
                self.showState(state)
            }
            
        case 30: // ambient light monitoring
            
            // 环境光监测，个别设备才支持
            // Ambient light monitoring, only supported by individual devices
            YCProduct.setDeviceAmbientLightMonitoringMode(isEnable: true, interval: 60) { state, response in
                self.showState(state)
            }
            
        case 31: // work mode
            
            /**
             
             /// Working mode
             @objc public enum YCDeviceWorkModeType : UInt8 {
                 case normal        // normal
                 case care          // care
                 case powerSaving   // power saving
                 case custom        // custom
             }
             
             */
            
            // 设置工作模式，个别设备才支持
            // Set the working mode, only supported by individual devices
            YCProduct.setDeviceWorkMode(mode: .normal) { state, response in
                
                self.showState(state)
            }
            
        case 32:    // 意外监测
            
            // 启动意外监测，个别设备才支持
            // Enable accidental monitoring, only supported by individual devices.
            YCProduct.setDeviceAccidentMonitoring(isEnable: true) { state, response in
                self.showState(state)
            }
            
        case 33: // reminder type
            
            /**
             
             /// Reminder setting type
             @objc public enum YCDeviceRemindType : UInt8 {
                 case deviceDisconnected   // Device disconnected
                 case sportsCompliance     // Sports standard
             }
             
             */
            
            // 设置不能的提醒类型，个别设备才支持
            // Set the type of reminder that cannot be set, only supported by individual devices
            YCProduct.setDeviceReminderType(isEnable: true, remindType: .deviceDisconnected) { state, response in
                
                self.showState(state)
            }
            
        case 34: // bloodOxygen monitoring
            
            // 血氧监测，部分设备才支持这个功能.
            // Blood oxygen monitoring, only some devices support this function.
            YCProduct.setDeviceBloodOxygenMonitoringMode(isEnable: true, interval: 60) { state, response in
                self.showState(state)
            }
            
        case 35: // temperature humidity monitoring
            
            // 温湿度监测，部分设备才支持这个功能。
            // Temperature and humidity monitoring, only some devices support this function.
            YCProduct.setDeviceTemperatureHumidityMonitoringMode(isEnable: true, interval: 60) { state, response in
                self.showState(state)
            }
            
        case 36: // upload reminder
            
            // 存储域值提醒，个别设备才支持。
            // Stored field value reminder, only supported by individual devices.
            YCProduct.setDeviceUploadReminder(isEnable: true, threshold: 50) { state, response in
                self.showState(state)
            }
            
        case 37: // pedometer time
            
            // 修改计步时间，个别设备才支持。
            // Modifying the pedometer time is only supported by individual devices.
            YCProduct.setDevicePedometerTime(time: 10) { state, response in
                self.showState(state)
            }
            
        case 38: // broadcast interval
            
            // 设置蓝牙广播间隔，个别设备才支持
            // Set the Bluetooth broadcast interval, only supported by individual devices.
            /// - interval: 20 ~ 10240ms
            YCProduct.setDeviceBroadcastInterval(interval: 20) { state, response in
                self.showState(state)
            }
            
        case 39: // transmit power
            
            // 设置设备的传输功率, 个别设备才支持
            // Set the transmission power of the device, only supported by individual devices
            ///   - power: DBM
            YCProduct.setDeviceTransmitPower(power: 0) { state, response in
                self.showState(state)
            }
            
        case 40: // hr zone
            
            /**
             /// Exercise type
             @objc public enum YCDeviceExerciseHeartRateType: UInt8 {
                 case retreat
                 case casualwarmup
                 case cardiorespiratoryStrengthening
                 case reduceFatShape
                 case sportsLimit
                 case emptyState
             }
             
             */
            
            // 设置运动心率范围，只有个别心率才支持。
            // Set the exercise heart rate range, only individual heart rate is supported.
            ///   - zoneType: YCDeviceExerciseHeartRateType
            ///   - minimumHeartRate: Maximum heart rate
            ///   - maximumHeartRate: Heart rate mi
            YCProduct.setDeviceExerciseHeartRateZone(zoneType: .retreat, minimumHeartRate: 60, maximumHeartRate: 100) { state, response in
                self.showState(state)
            }
            
        case 41: // Insurance
            
            // 开启保险显示界面，个别设备才支持。
            // Open the insurance display interface, only individual devices are supported.
            YCProduct.setDeviceInsuranceInterfaceDisplay(isEnable: true) { state, response in                
                self.showState(state)
            }
            
        case 42:
            
            // 设置不同工作模式下的数据采集，只有个别设备支持。
            // Set data collection in different working modes, only supported by individual devices.
            YCProduct.setDeviceWorkModeDataCollection(mode: .normal, dataType: .ppg, acquisitionTime: 90, acquisitionInterval: 60) { state, response in
                self.showState(state)
            }
            
        case 43: // bp alarm
            
            // 设置血压报警，部分设备才支持。
            // Setting a blood pressure alarm is only supported by some devices.
            ///   - isEnable: Whether to open
            ///   - maximumSystolicBloodPressure: Maximum systolic blood pressure
            ///   - maximumDiastolicBloodPressure: Maximum diastolic blood pressure
            ///   - minimumSystolicBloodPressure: Minimum systolic blood pressure
            ///   - minimumDiastolicBloodPressure: Minimum diastolic blood pressure
            YCProduct.setDeviceBloodPressureAlarm(isEnable: true, maximumSystolicBloodPressure: 250, maximumDiastolicBloodPressure: 140, minimumSystolicBloodPressure: 160, minimumDiastolicBloodPressure: 90) { state, response in
                self.showState(state)
            }
            
        case 44: // spo2 alarm
            
            // 设置血氧报警，部分设备才支持。
            // Setting the blood oxygen alarm is only supported by some devices.
            ///   - isEnable: Whether to open
            ///   - minimum: Minimum blood oxygen level
            YCProduct.setDeviceBloodOxygenAlarm(isEnable: true, minimum: 88) { state, response in
                self.showState(state)
            }
            
        case 45:
            
            // 设置马达震动时间，只有个别设备才支持。
            // Set the motor vibration time, only supported by individual devices.
            ///   - mode: Motor vibration type
            ///   - time: Duration in milliseconds
            YCProduct.setDeviceMotorVibrationTime(time: 2 * 1000) { state, response in
                self.showState(state)
            }
            
        case 46: // query alarm
            
            /**
             YCDeviceAlarmInfo
             
             /// Alarm information
             @objc public class YCDeviceAlarmInfo : NSObject {
                
             /// Maximum number of alarms allowed by the device
                 public  var limitCount: UInt8 { get }
                 
             /// Alarm type
                 public  var alarmType: YCProductSDK.YCDeviceAlarmType { get }
                
             /// Hour 0 ~ 23
                 public  var hour: UInt8 { get }
                
             /// Minute 0 ~ 59
                 public  var minute: UInt8 { get }
                
             /// Repeat
                 public  var `repeat`: Set<YCProductSDK.YCDeviceWeekRepeat> { get }
                
             /// Snooze time (minute)
                 public  var snoozeTime: UInt8 { get }
             }
             
             /// Alarm type
             @objc public enum YCDeviceAlarmType : UInt8 {
                 case wakeUp
                 case sleep
                 case exercise
                 case medicine
                 case appointment
                 case party
                 case meeting
                 case custom
             }
             
             */
            
            // 查询闹钟
            // Query the alarm clock
            YCProduct.queryDeviceAlarmInfo { state, response in
                if state == .succeed,
                let datas = response as? [YCDeviceAlarmInfo] {
                    var str = "["
                    for item in datas {
                        str += item.toString
                        str += "\n"
                    }
                    str += "]"
                    
                    self.textView.text = str
                } else {}
                
                self.showState(state)
            }
        
        case 47:  // add alarm
            
            ///   - alarmType: Alarm type
            /// -hour:0~23
            /// -minute:0~59
            ///   - repeat: Repeat time
            ///   - snoozeTime: Snooze time 0~59minutes
            YCProduct.addDeviceAlarm(alarmType: .wakeUp, hour: 6, minute: 30, repeat: [.enable, .sunday, .saturday], snoozeTime: 0) { state, response in
                
                self.showState(state)
            }
            
        case 48: // delete alarm
            
            /// -hour:0~23
            /// -minute:0~59
            YCProduct.deleteDeviceAlarm(hour: 6, minute: 30) { state, response in
                
                self.showState(state)
            }
            
        case 49: // modify alarm
            
            ///   - oldHour: The original hour of the alarm clock
            ///   - oldMinute: The original minute of the alarm
            ///   - hour: Alarm clock new hour
            ///   - minute: Alarm new minute
            ///   - alarmType: Alarm type
            ///   - repeat: Repeat time
            ///   - snoozeTime: Snooze time
            YCProduct.modifyDeviceAlarm(oldHour: 6, oldMinute: 30, hour: 11, minute: 0, alarmType: .meeting, repeat: [.enable, .monday], snoozeTime: 0) { state, response in
                self.showState(state)
            }
            
            
        case 50: // event enable
            
            // 个别设备才支持,
            // Only supported by individual devices
            YCProduct.setDeviceEventEnable(isEnable: true) { state, response in
                self.showState(state)
            }
            
        case 51: // add event
            
            // 个别设备才支持
            // Only supported by individual devices
            
            ///   - name: <= 12 bytes, no more than 4 Chinese
            ///   - isEnable: Whether to enable
            /// -hour: 0~23
            ///   - minute: 0 ~ 59
            ///   - interval: Repeat reminder interval
            ///   - repeat: Repeat week
            YCProduct.addDeviceEvent(name: "party", isEnable: true, hour: 19, minute: 50, interval: .ten, repeat: [.enable, .saturday]) { state, respose in
                
                self.showState(state)
            }
            
        case 52: // delete event
            
            // 个别设备才支持
            // Only supported by individual devices
            
            ///   - eventID: 1 ~ 10
            YCProduct.deleteDeviceEvent(eventID: 1) { state, _ in
                self.showState(state)
            }
            
        case 53: // modify event
            
            // 个别设备才支持
            // Only supported by individual devices
            
            ///   - name: Event name
            ///   - eventID: Event id
            ///   - isEnable: Whether to open
            /// -hour:0~23
            ///   - minute: 0 ~ 59
            ///   - interval: Time interval
            ///   - repeat: Repeat time
            YCProduct.modifyDeviceEvent(name: "sleep", eventID: 1, isEnable: true, hour: 22, minute: 30, interval: .twenty, repeat: [.enable, .monday, .tuesday, .wednesday, .thursday, .friday]) { state, _ in
                self.showState(state)
            }
            
        case 54: // query event
            
            // 个别设备才支持
            // Only supported by individual devices
            
            /**
             
             /// event information
             @objcMembers public class YCDeviceEventInfo : NSObject {
                  
                 /// Event ID
                 public var eventID: UInt8 { get }
                 
                 /// Whether to open
                 public var isEnable: Bool { get }
                 
                 /// Event hour 0 ~ 23
                 public var hour: UInt8 { get }
                 
                 /// Event minutes 0 ~ 59
                 public var minute: UInt8 { get }
                 
                 /// Event repeat
                 public var `repeat`: Set<YCDeviceWeekRepeat> { get }
                 
                 /// Event interval
                 public var interval: YCDeviceEventInterval { get }
                 
                 /// Event name
                 public var name: String { get }
             }
             
             */
            
            YCProduct.queryDeviceEventnfo { state, response in
                
                if state == .succeed, let datas = response as? [YCDeviceEventInfo] {
                    
                    print("success")
                    for item in datas {
                        print(item.name, item.eventID,
                              item.hour, item.minute)
                    }
                } else {
                    
                    self.showState(state)
                }
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
        } else if state == .alarmNotExist {
            self.textView.text = "Alarm not exist"
        } else if state == .alarmCountLimit {
            self.textView.text = "Alarm reached the upper limit"
        } else if state == .alarmAlreadyExist {
            self.textView.text = "Alarm already exist"
        } else if state == .alarmTypeNotSupport {
            self.textView.text = "alarm type not support"
        }
    }
}


extension YCSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        exampleForItems(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1,
           YCProduct.shared.currentPeripheral?.supportItems.isSupportStep != true {
            
            return 0
            
        } else if indexPath.row == 2 ||
                    indexPath.row == 3 ||
                    indexPath.row == 5 ||
                    indexPath.row == 6 {
            
            return 0
        
        } else if indexPath.row == 4,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportSleep != true {
        
            return 0
            
        } else if indexPath.row == 9, YCProduct.shared.currentPeripheral?.supportItems.isSupportSedentaryReminder != true {
            
            return 0
        
        } else if indexPath.row == 10,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportAntiLostReminder != true {
            
            return 0
        
        } else if indexPath.row == 12,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportHeartRateAlarm != true {
        
            return 0
        
        } else if indexPath.row == 13,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportHeartRate != true {
        
            return 0
            
        } else if indexPath.row == 14,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportDoNotDisturbMode != true {
            
            return 0
        
        } else if indexPath.row == 17,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportWristBrightScreen != true {
            
            return 0
        
        } else if indexPath.row == 19,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportSkinColorSettings != true {
        
            return 0
            
        } else if indexPath.row == 20 {
            
            if YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodPressureCalibration == true {
                
                return 0
                
            } else {
            
                if YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodPressureLevelSetting != true {
                    
                    return 0
                }
            }
            
        } else if indexPath.row == 21 ||
                    indexPath.row == 22 ||
                    indexPath.row == 24 ||
                    indexPath.row == 25 {
            
            return 0
        
        } else if indexPath.row == 23,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportTheme != true {
        
            return 0
        
        } else if indexPath.row == 26,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodPressure != true {
            
            return 0
        
        } else if indexPath.row == 27,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportTemperatureAlarm != true {
            
            return 0
        
        } else if indexPath.row == 28,
                  YCProduct.shared.currentPeripheral?.supportItems.isSupportTemperature != true {
        
            return 0
        
        } else if indexPath.row >= 29 &&
                    indexPath.row <= 45 {
            
            return 0
        
        } else if indexPath.row >= 50 &&
                    indexPath.row <= 54 {
            
            return 0
        }
        
        return 49
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableView.self), for: indexPath)
        
        cell.textLabel?.text = // "\(indexPath.row + 1). " +
            items[indexPath.row]
        
        if indexPath.row == 1 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportStep != true
            
        } else if indexPath.row == 2 ||
                    indexPath.row == 3 ||
                    indexPath.row == 5 ||
                    indexPath.row == 6 {
            
            cell.isHidden = true
        
        } else if indexPath.row == 4 {
        
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportSleep != true
            
        } else if indexPath.row == 9 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportSedentaryReminder != true
        
        } else if indexPath.row == 10 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportAntiLostReminder != true
        
        } else if indexPath.row == 12 {
        
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportHeartRateAlarm != true
        
        } else if indexPath.row == 13 {
        
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportHeartRate != true
            
        } else if indexPath.row == 14 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportDoNotDisturbMode != true
        
        } else if indexPath.row == 17 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportWristBrightScreen != true
        
        } else if indexPath.row == 19 {
        
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportSkinColorSettings != true
            
        } else if indexPath.row == 20 {
            
            if YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodPressureCalibration == true {
                
                cell.isHidden = true
                
            } else {
            
                cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodPressureLevelSetting != true
            }
            
        } else if indexPath.row == 21 ||
                    indexPath.row == 22 ||
                    indexPath.row == 24 ||
                    indexPath.row == 25 {
            
            cell.isHidden = true
        
        } else if indexPath.row == 23 {
        
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportTheme != true
        
        } else if indexPath.row == 26 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodPressure != true
        
        } else if indexPath.row == 27 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportTemperatureAlarm != true
        
        } else if indexPath.row == 28 {
        
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportTemperature != true
        
        } else if indexPath.row >= 29 &&
                    indexPath.row <= 45 {
            
            cell.isHidden = true
        
        } else if indexPath.row >= 50 &&
                    indexPath.row <= 54 {
            
            cell.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
