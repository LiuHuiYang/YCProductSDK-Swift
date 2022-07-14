//
//  YCECGResultViewCell.swift
//  SmartHealthPro
//
//  Created by yc on 2020/12/2.
//  Copyright © 2020 yc. All rights reserved.
//

import UIKit
import YCProductSDK

class YCECGResultViewCell: UITableViewCell {
    
    /// ECG的数据信息
    var ecgInfo = YCHealthLocalECGInfo() {
        
        didSet {
            
            setupInfo()
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        return 225
    }

    
    @IBOutlet weak var topTitleView: UIView!
    
    /// 标题的父视图
    @IBOutlet weak var resultTitleView: UIView!
    
    @IBOutlet weak var resultTitleLabel: UILabel!
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var heartRateLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
         
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
        selectionStyle = .none
        
    }
    
    private func setupInfo() {
        
        resultTitleLabel.text = "Results"
        
        var result = ""
        var detail = ""
        if ecgInfo.afflag {
            
            result = "Suspected atrial fibrillation"
            detail = "QRS waveform was normal, normal P wave disappeared, F wave appeared, R-R interval was irregular."
        
        } else if ecgInfo.qrsType == PVC {
        
            result = "Suspected ventricular premature beats"
            detail = "The qrs-t waveform was wide and deformed. There was no related P wave before the QRS waveform. The QRS duration was > 0.9 seconds. The direction of T wave was opposite to that of the main wave."
            
        } else if ecgInfo.qrsType == SVPB {
            
            result = "Suspected atrial premature beats"
            
            detail = "QRS waveform was normal, variant P wave appeared ahead of time, P-R > 0.9 s, compensation interval was incomplete."
            
        } else if ecgInfo.heartRate <= 50 {
            
            result = "Suspected bradycardia"
            
            detail = "The QRS waveform was normal and the R-R interval was too long."
            
        } else if ecgInfo.heartRate >= 120 {
            
            result = "Suspected tachycardia"
            detail = "The QRS waveform was normal and the R-R interval was short."
            
        } else if ecgInfo.hrv >= 125 {
            
            result = "Suspected sinus arrhythmia"
            detail = "The QRS waveform was normal, and the R-R interval changed too much"
            
        } else if ecgInfo.qrsType == NORMAL { // 必须放在最后
            
            result = "Normal electrocardiogram"
            detail = "The amplitude of QRS waveform was normal, P-R interval was normal, ST-T was not changed, and Q-T interval was normal."
        }
        
        resultLabel.text = result
        
        heartRateLabel.attributedText = setupAttributedString("\t\("Heart rate")\t", detail: "\t\(ecgInfo.heartRate)")
        
        
        detailLabel.attributedText = setupAttributedString("\t\("Detail")\t", detail: "\t" + detail)
    }
    
    /// 设置多文本文字
    private func setupAttributedString(_ prefix: String, detail: String) -> NSMutableAttributedString {
        
        let attributeDictionary: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            
            NSAttributedString.Key.foregroundColor: UIColor.white,
            
            NSAttributedString.Key.backgroundColor: UIColor(red: 45.0/255.0, green: 70.0/255.0, blue: 66.0/255.0, alpha: 1.0)
             
        ]
        
        let string = NSMutableAttributedString(string: prefix)
        
        string.setAttributes(attributeDictionary,
                             range: NSMakeRange(0, string.length))
        
        string.append(NSAttributedString(string: detail))
        
        return string
    }
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
