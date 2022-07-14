//
//  YCECGShowViewController.swift
//  SmartHealthPro
//
//  Created by yc on 2020/12/3.
//  Copyright © 2020 yc. All rights reserved.
//

import UIKit
import YCProductSDK

class YCECGShowViewController: UIViewController {
    
    /// ECG的数据信息
    var ecgInfo = YCHealthLocalECGInfo()
    
    var ecgLineView = YCECGDrawLineView()
    
    
    @IBOutlet weak var bloodPressureLabel: UILabel!
    
    @IBOutlet weak var heartRateLabel: UILabel!
    
    @IBOutlet weak var hrvLabel: UILabel!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    /// 设置显示值
    private func setupShowValue() {
        
        if ecgInfo.diastolicBloodPressure > 0 &&
            ecgInfo.systolicBloodPressure > 0{
            
            bloodPressureLabel.text =
            "blood pressure:  \(ecgInfo.systolicBloodPressure)/\(ecgInfo.diastolicBloodPressure)"
        }
        
        
        if ecgInfo.heartRate > 0 {
            heartRateLabel.text =
            "heart: \(ecgInfo.heartRate)"
        }
        
        if ecgInfo.hrv > 0 {
            hrvLabel.text = "hrv: \(ecgInfo.hrv)"
        }
    }
 
    /// 画线
    private func drawECGLine() {
        
        let drawECGDatas =
        YCECGManager.getDrawECGLineData(ecgInfo.ecgDatas, gridSize: Float(CELL_SIZE), count: 20)
        
        // 每个数据的宽度 0.1 X 格子 X 3(逢三取一)
        let width = CELL_SIZE * 0.3
        
        var totalWidth = CGFloat(drawECGDatas.count) * CGFloat(width)
        
        if totalWidth < SCREEN_WIDTH {
            totalWidth = SCREEN_WIDTH
        }
        
        scrollView.addSubview(ecgLineView)
        ecgLineView.frame = CGRect(x: 0, y: 0, width: totalWidth, height: SCREEN_HEIGHT)
        
        let showLabel = UILabel(frame: CGRect(x: 10, y: SCREEN_HEIGHT - 64, width: totalWidth, height: 30))
  
        showLabel.textColor = UIColor.darkGray
        showLabel.textAlignment = .left
        showLabel.text = "Gain: 10mm/mv Travel speed: 25mm/s Ⅰ lead"
        scrollView.addSubview(showLabel)
         
        
        scrollView.contentSize =
            CGSize(width: totalWidth, height: SCREEN_HEIGHT)        
        
        ecgLineView.datas = drawECGDatas
        ecgLineView.drawReferenceWaveformStype = .top
        
        ecgLineView.setNeedsDisplay()
    }
    
    /// 设置UI
    private func setupUI() {
        
        navigationItem.title = "Hhistory record"
        setupShowValue()
        drawECGLine()
    }
}
