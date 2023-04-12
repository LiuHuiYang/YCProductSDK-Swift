//
//  YCECGMeasureViewController.swift
//  SmartHealthPro
//
//  Created by yc on 2020/11/25.
//  Copyright © 2020 yc. All rights reserved.
//

import UIKit
import YCProductSDK
import AVFoundation

public let SCREEN_WIDTH = UIScreen.main.bounds.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.height
public let HRV_LIMIT_VALUE = 150


// https://news.medlive.cn/heart/info-progress/show-139154_129.html

/// 测量心电数据最少数量 Measure the minimum amount of ECG data
public let MEASURE_DATA_LIMIT_COUNT = 2800

/// 测量中断直接补0的个数 Measure the number of interrupts directly filled with 0
private let FILL_DATA_COUNT = 250

/// 测量时间为60秒 Measurement time is 60 seconds
private let MEASURE_TIME = 60

class YCECGMeasureViewController: UIViewController {
    
    // MARK: - 测试结果 measure Results
    
    /// 测试hrv measure hrv
    private var hrvValue = 0
    
    /// 测试心率 measure heart rate
    private var heartRate = 0
    
    /// 测试收缩压 measure systolic blood pressure
    private var systolicBloodPressure = 0
    
    /// 测试舒张压 measure diastolic blood pressure
    private var diastolicBloodPressure = 0
    
    
     
    // MARK: - 测试过程 Measurement process
    
    
    /// 正在测量
    private var isMeasuring = false
    
    private var aicheckDatas = [Int]()
    
    /// 测试中断又恢复正常时的异常值变为直线的处理
    private var isInterruptDataCount = 0
    
    /// 绘图波形的最大值
    private var drawDataMax = 0
    
    /// 绘图波形的最小值
    private var drawDataMin = 0
    
    /// 绘制图形用的数据集合
    private var drawLineDatas = [Int]()
    
    /// 当前ECG数据的前一个
    private var previousData: Float = 0
    
    /// 当前ECG数据的上一个的上一个
    private var previousPreviousData: Float = 0
    
    /// 处理ECG的数量
    private var ecgDataCount = 0
    
    /// ECG的原始数据
    private var ecgOriginalDatas = [Int32]()
    
    /// 正在接收ECG数据
    private var isReceivingECGData: Bool = false
    
    /// 是否使用手环的HRV
    private var isUseDeviceHRV: Bool = false
    
    
    /// 绘制数据的序号
    private var drawLineIndex = 0
    
    /// 画线的定时器
    private var drawLineTimer: Timer?
    
    /// 测量定时器
    private var measurementTimer: Timer?
    
    /// 测量时间
    private var measurementTime = 0
    
    /// 画线的控件
    private var ecgLineView: YCECGDrawLineView = YCECGDrawLineView()
    
    /// ecg算法工具类
    private var ecgAlgorithmManager = YCECGManager()
    
    /// 测量ECG声音
    private let audioPlayer: AVAudioPlayer = {
        
        guard let path =
            Bundle.main.path(forResource: "ecg_tip",
                             ofType: "m4a") else {
                
                return AVAudioPlayer()
            }
        
        let url = URL(fileURLWithPath: path)
        guard let play = try? AVAudioPlayer(contentsOf: url) else {
            
            return AVAudioPlayer()
        }
        
        play.volume = 1.0
        play.numberOfLoops = 0
        play.prepareToPlay()
        
        return play
    }()
    
    // MARK: - UI控件属性
    
    // MARK: - 提示界面
    
    /// 确定按钮
    @IBOutlet weak var sureButton: UIButton!
    
    // MARK: - 中间UI
    
    /// 电极状态按钮的宽度
    @IBOutlet weak var electrodeStateButtonWidthConstraint: NSLayoutConstraint!
    
    /// 电极按钮状态
    @IBOutlet weak var electrodeStateButton: UIButton!
    
    /// 测量提示按钮
    @IBOutlet weak var measurementTipsView: UIView!
    
    /// 开始测量按钮
    @IBOutlet weak var startMeasuringButton: UIButton!
    
    /// 测量进度view
    @IBOutlet weak var measureProgressView: YCGradientProgressView!
    
    /// 进度值
    @IBOutlet weak var measureProgressLabel: UILabel!
    
    /// ECG测试画线的背景格子
    @IBOutlet weak var ecgMeasurebackgroundView: UIView!    

    
    // MARK: - 顶部测试界面
    
    /// 心率值
    @IBOutlet weak var heartRateValueLabel: UILabel!
    
    /// 心率单位
    @IBOutlet weak var heartRateUnitLabel: UILabel!
    
    /// 血压值
    @IBOutlet weak var bloodPressureValueLabel: UILabel!
    
    /// 血压单位
    @IBOutlet weak var bloodPressureUnitLabel: UILabel!
    
    /// HRV值
    @IBOutlet weak var hrvValueLabel: UILabel!
    
    /// hrv单位
    @IBOutlet weak var hrvUnitLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
         
        setupECGNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        destoryECGNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
 
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
        
        // set skin tone
        ///   - level: color
        YCProduct.setDeviceSkinColor(level: .yellow) { state, response in
             
            /**
             
             /// Wearing position
             @objc public enum YCDeviceWearingPositionType : UInt8 {
                 case left   // Left hand
                 case right  // Right hand
             }
             
             */
            
            // 设置左右手佩戴位置
            // Set the left and right hand wearing position
            ///   - wearingPosition: Wearing position
            YCProduct.setDeviceWearingPosition(wearingPosition: .left) { state, response in
                 
                if state == .succeed {
                    
                }
            }
        }
    }
     
    
}

// MARK: - UI初始化
extension YCECGMeasureViewController {
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopMeasuringECG()
    }
    
    
    /// 设置基础UI
    private func setupUI() {
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "ECG Measure"
         
        
        setupMeasuringButtonStutus()
        
        ecgMeasurebackgroundView.addSubview(ecgLineView)
        
        
        ecgLineView.drawReferenceWaveformStype = .top
        
        setupElectrodeStateButton()
        
        setupTipsView()
    }
    
    /// 设置电极按钮
    private func setupElectrodeStateButton() {
        
        electrodeStateButton.setTitle(
            "electrode ok", for: .normal
        )
        
        electrodeStateButton.backgroundColor = UIColor(red: 0, green: 196.0/255.0, blue: 149.0/255.0, alpha: 1.0)
          
        electrodeStateButton.isHidden = true
         
    }
    
    /// 设置提示按钮
    private func setupTipsView() {
        
        measurementTipsView.isHidden = true
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ecgLineView.frame = ecgMeasurebackgroundView.bounds
    }
}

// MARK: - 提示界面相关
extension YCECGMeasureViewController {
    
    /// 确定按钮点击
    /// - Parameter sender: <#sender description#>
    @IBAction func sureButtonClick(_ sender: UIButton) {
        
        startMeasuringECG()
    }
}

// MARK: - 绘制ECG相关
extension YCECGMeasureViewController {
    
    /// 测试计时
    @objc private func measuringTiming() {
        
        measurementTime += 1
        
        // 计算测试进度
        let process =
            Float(measurementTime)/Float(MEASURE_TIME)
        
        measureProgressView.progress = process
        measureProgressLabel.text = "\(Int(process * 100))%"
        
        // 判断电极脱落
        electrodeStateButton.isHidden = false
        
        if (measurementTime % 2) == 0 {
            
            if isReceivingECGData {
                
                electrodeStateButton.setTitle(
                    "electrode ok",
                    for: .normal)
                 
                electrodeStateButton.titleLabel?.tintColor =
                    UIColor.blue
                
            } else {
                
                electrodeStateButton.setTitle(
                    "electrode fails off",
                    for: .normal)
                 
                electrodeStateButton.titleLabel?.tintColor =
                    UIColor.red
                
                self.isInterruptDataCount = drawLineDatas.count
                
            }
            
            // 重置标志位
            isReceivingECGData = false
        }
        
        
        // 测试完成
        if measurementTime >= MEASURE_TIME {
            
            // 延时执行为了可以显示测量进度 100%
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [weak self] in
                
                self?.stopMeasuringECG()
            }
        }
    }
    
    
    /// 设置测试定时器
    private func setupMeasurementTimer() {
        
        if measurementTimer != nil {
            measurementTimer?.invalidate()
            measurementTimer = nil
        }
        
        measurementTime = 0
        
        let timer =
            Timer.scheduledTimer(timeInterval: 1.0,
                                 target: self,
                                 selector: #selector(measuringTiming),
                                 userInfo: nil,
                                 repeats: true)
        
        measurementTimer = timer
    }
    
    
    /// 设置绘图的定时器
    private func setupDarwEcgLineTimer() {
        
        let timer =
            Timer.scheduledTimer(
                timeInterval: 1.0 / 250.0 * 3,
                target: self,
                selector: #selector(drawEcgLine),
                userInfo: nil,
                repeats: true)
        
        drawLineTimer = timer
        drawLineIndex = 0
    }
    
    
    /// 绘制ECG的线条
    @objc private func drawEcgLine() {
        
        // 正常走纸速度 1s 25mm/s 就是25小格
        // 每格就10个数据 (250HZ的采集频率)
        // 每个点的距离是 0.1个小格子
        let distance = CELL_SIZE * 0.1 * 3
        
        let datasCount = drawLineDatas.count
        
        if CGFloat(ecgLineView.datas.count) * CGFloat(distance) < SCREEN_WIDTH {
            
            if drawLineIndex < datasCount {
                
                let data = drawLineDatas[drawLineIndex]
                ecgLineView.datas.add(data)
                
                drawLineIndex += 1
            }
            
        } else {
            
            if drawLineIndex < datasCount {
                
                ecgLineView.datas.removeObject(at: 0)
                let data = drawLineDatas[drawLineIndex]
                ecgLineView.datas.add(data)
                
                drawLineIndex += 1
            }
        }
        
        ecgLineView.setNeedsDisplay()
    }
}

// MARK: - 接收数据
extension YCECGMeasureViewController {
    
    
    /// 转换康源需要的ECG数据
    private func aicheckECGDataToServer() -> [Int] {
        
        var listDatas = [Int]()
        
        let datas = aicheckDatas.sorted { (item1, item2) -> Bool in
            return item1 < item2
        }
        
        aicheckDatas = datas
        
        var radio = 0.0
        var sum = 0
        var count = 0
        
        let aiDataCount = aicheckDatas.count
        
        if aicheckDatas.count > 11 {
            
            let startIndex = 5
            let endIndex = aiDataCount - 10
            
            for index in startIndex ..< endIndex {
                
                sum += aicheckDatas[index]
                count += 1
            }
            
            radio = Double(sum)/Double(count)
        }
        
        if radio < 50 {
            
            radio = 50 / radio
            
        } else {
            radio = 1
        }
        
        var offset = 330
        let boundaryValue = 400
        let listLength = drawLineDatas.count
        
        while offset < listLength {
            
            var tempData =
                Int(Double(drawLineDatas[offset]) * radio)
            
            if tempData > boundaryValue {
                
                tempData = boundaryValue
                
            } else if tempData < -boundaryValue {
                
                tempData = -boundaryValue
            }
            
            listDatas.append(tempData)
            offset += 1
        }
        
        return listDatas
    }
    
    /// 处理ECG数据
    private func parseECGdata(_ datas: [Int32]) {
        isReceivingECGData = true
        ecgOriginalDatas.append(contentsOf: datas)
        
        for data in datas {
            
            var ecgValue: Float = 0
            
            ecgValue = ecgAlgorithmManager.processECGData(Int(data))
            
            if (ecgDataCount % 3) == 0 {
                
                let tempEcgData =
                    (ecgValue + previousData + previousPreviousData) / 3.0
                
                // tempEcgData / 40 / 1000  ==> mv * 10 = 格子数 * 每格大小
                var drawData =
                    Int(Double(tempEcgData) / 4000.0 * CELL_SIZE)
                let limitValue = Int(CELL_SIZE * 20)
                
                if drawData > limitValue {
                    drawData = limitValue
                }
                
                if drawData < -limitValue {
                    drawData = -limitValue
                }
                
                // 刚开始还没有数据
                if drawLineDatas.isEmpty {
                    
                    setupMeasurementTimer()
                    setupDarwEcgLineTimer()
                }
                
                // 测试过程中
                if drawLineDatas.count < (FILL_DATA_COUNT +
                                            self.isInterruptDataCount) {
                    
                    drawLineDatas.append(0)
                    
                } else {
                    
                    drawLineDatas.append(drawData)
                    
                    if drawData > drawDataMax {
                        
                        drawDataMax = drawData
                        
                    } else if drawData < drawDataMin {
                        
                        drawDataMin = drawData
                    }
                }
            }
            
            previousPreviousData = previousData
            previousData = ecgValue
            ecgDataCount += 1
        }
    }
    
    @objc private func receiveRealTimeData(_ notification: Notification) {
        
        guard let info = notification.userInfo else {
            return
        }
        
        // 数据
        if let healthData =  (info[YCReceivedRealTimeDataType.bloodPressure.string] as? YCReceivedDeviceReportInfo)?.data as? YCReceivedRealTimeBloodPressureInfo  {
            
            heartRate = healthData.heartRate
            systolicBloodPressure =
                healthData.systolicBloodPressure
            diastolicBloodPressure =
                healthData.diastolicBloodPressure
            
            if healthData.hrv > 0 {
                
                if healthData.hrv > 0 &&
                    healthData.hrv <= HRV_LIMIT_VALUE {
                
                    isUseDeviceHRV = true
                    hrvValueLabel.text = "\(healthData.hrv)"
                    self.hrvValue = healthData.hrv
                }
            }
            
            heartRateValueLabel.text = "\(heartRate)"
            bloodPressureValueLabel.text = "\(systolicBloodPressure)/\(diastolicBloodPressure)"
        }
        
        /// ECG数据
        if let ecgData = (info[YCReceivedRealTimeDataType.ecg.string] as? YCReceivedDeviceReportInfo)?.data as? [Int32] {
             
            parseECGdata(ecgData)
        }
        
        // ppg据
        if let ppgData = (info[YCReceivedRealTimeDataType.ppg.string] as? YCReceivedDeviceReportInfo)?.data as? [Int32] {
            
            print(ppgData)
        }
        
    }
      
    
    /// 设置ECG通知
    private func setupECGNotification() {
         
        NotificationCenter.default.addObserver(self, selector: #selector(receiveRealTimeData(_:)), name: YCProduct.receivedRealTimeNotification, object: nil)
 
    }
    

    /// 销毁ECG通知
    private func destoryECGNotification() {
        
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - ECG Measure
extension YCECGMeasureViewController {
    
    /// 显示ECG测试报告 show Report
    private func showECGMeaaurementReport(_ result: YCECGMeasurementResult) {
        
        let vc = YCECGReportViewController()
        let ecgInfo = YCHealthLocalECGInfo()
        
        ecgInfo.heartRate = heartRate
        ecgInfo.hrv = hrvValue
        ecgInfo.systolicBloodPressure = systolicBloodPressure
        ecgInfo.diastolicBloodPressure = diastolicBloodPressure
        ecgInfo.ecgDatas = ecgOriginalDatas
        ecgInfo.qrsType = result.qrsType
        ecgInfo.afflag = result.afflag
        
        vc.ecgInfo = ecgInfo
        
        navigationController?.pushViewController(vc, animated: true)
  
    }
    
    /// 结束测试
    private func stopMeasuringECG(_ ignoreResult: Bool = false) {
        
        // 定时器失效 标志位重置
        drawLineTimer?.invalidate()
        drawLineTimer = nil
        
        measurementTimer?.invalidate()
        measurementTimer = nil
        
        isReceivingECGData = false
        isMeasuring = false
        
        measurementTime = 0
        drawLineIndex = 0
        
        electrodeStateButton.isHidden = true
        
        // 结束测试
        YCProduct.stopECGMeasurement { state, response in
            
        }
        
        // 不处理结果
        if ignoreResult {
            return
        }
        
        // 对结果进行处理
        if drawLineDatas.count <= MEASURE_DATA_LIMIT_COUNT {
             
            setupMeasuringButtonStutus()
            return
        }
        
        // get ecg result
        ecgAlgorithmManager.getECGMeasurementResult(deviceHeartRate: heartRate > 0 ? heartRate : nil, deviceHRV: hrvValue > 0 ? hrvValue : nil) { result in
            
            print(result.hearRate,
                  result.hrv,
                  result.ecgMeasurementType == .normal
            )
            
            
//            let bodyInfo =
//            self.ecgAlgorithmManager.getPhysicalIndexParameters()
//
//            if bodyInfo.isAvailable {
//
//                print("heavyLoad = \(bodyInfo.heavyLoad), pressure = \(bodyInfo.pressure), hrvNorm = \(bodyInfo.hrvNorm), body = \(bodyInfo.body) ")
//            }
            
          
            // 展示测试报告
            self.showECGMeaaurementReport(
                result
            )
            
        }
        

        hrvValueLabel.text = "\(hrvValue)"
        
        if heartRate > 0 {
            heartRateValueLabel.text = "\(heartRate)"
        }
        
        if systolicBloodPressure > 0 &&
            diastolicBloodPressure > 0 {
            
            bloodPressureValueLabel.text =
                "\(systolicBloodPressure)/\(diastolicBloodPressure)"
        }
        
        setupMeasuringButtonStutus()
    }
    
    /// 开始测试
    private func startMeasuringECG() {
        
        // 清空数据
        self.hrvValue = 0
        self.heartRate = 0
        self.systolicBloodPressure = 0
        self.diastolicBloodPressure = 0
        self.hrvValueLabel.text = "--"
        self.bloodPressureValueLabel.text = "--/--"
        self.heartRateValueLabel.text = "--"
        measurementTipsView.isHidden = true
        electrodeStateButton.isHidden = true
        
        drawLineDatas.removeAll()
        aicheckDatas.removeAll()
        ecgOriginalDatas.removeAll()
        ecgLineView.datas.removeAllObjects()
        
        isInterruptDataCount = 0
        isReceivingECGData = false
        isUseDeviceHRV = false
        
        isMeasuring = true
        setupMeasuringButtonStutus()
        
        ecgLineView.setNeedsLayout()
        ecgLineView.setNeedsDisplay()
        
        ecgAlgorithmManager = YCECGManager()
        ecgAlgorithmManager.setupManagerInfo { [weak self] rr, heartRate in
            
            //  检查到RR间隔 
            self?.audioPlayer.play()
            
        } hrv: {  [weak self] hrv in
            
            if self?.isUseDeviceHRV == true {
                return
            }

            self?.hrvValue = hrv

            if hrv >= HRV_LIMIT_VALUE {

                self?.hrvValue = HRV_LIMIT_VALUE
            }

            self?.hrvValueLabel.text = "\(self?.hrvValue ?? 0)"
        }
        
        // 开始测试
        YCProduct.startECGMeasurement { state, response in
            
            if state == .succeed {
                
            }
        }
    }
    
    
    /// 点击开始测量
    /// - Parameter sender: <#sender description#>
    @IBAction func startMeasuringButtonClick(_ sender: UIButton) {
        
        if isMeasuring {
            
            stopMeasuringECG()
            return
        }
        
        measurementTipsView.isHidden = false
    }
    
    /// 设置测试按钮的状态
    private func setupMeasuringButtonStutus() {
        
        if isMeasuring {
            
            startMeasuringButton.setTitle(
                "Stop",
                for: .normal
            )
            
        } else {
            
            startMeasuringButton.setTitle(
                "Start",
                for: .normal
            )
            
            measureProgressView.layer.cornerRadius = 0
            measureProgressView.progressCornerRadius = 0
            measureProgressView.progressColors = [UIColor.red]
            measureProgressView.animationDuration = 0.0
            measureProgressView.progress = 0.0
            measureProgressLabel.text = ""
        }
    }
}
