//
//  YCHealthECGData.swift
//  SmartHealthPro
//
//  Created by yc on 2020/11/26.
//  Copyright © 2020 yc. All rights reserved.
//

import Foundation
import YCProductSDK

/// 本地ECG数据
@objcMembers class YCHealthLocalECGInfo: NSObject {
    
    /// hrv值
    var hrv: Int = 0
    
    /// 心率
    var heartRate: Int = 0
    
    /// 舒张压
    var systolicBloodPressure: Int = 0
    
    /// 收缩压
    var diastolicBloodPressure: Int = 0
    
    /// 房颤标记
    var afflag: Bool = false
    
    /// 心电类型
    var qrsType: Int = 0
    
    /// 使用的数据
    var ecgDatas: [Int32] = [Int32]()
    
}


