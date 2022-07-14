//
//  YCECGDiseaseScreeningViewCell.swift
//  SmartHealthPro
//
//  Created by yc on 2020/12/2.
//  Copyright © 2020 yc. All rights reserved.
//

import UIKit
import YCProductSDK

class YCECGDiseaseScreeningViewCell: UITableViewCell {
    
    /// ECG的数据信息
    var ecgInfo = YCHealthLocalECGInfo() {
        
        didSet {
            
            if ecgInfo.afflag {
                
                itemIndex = 0
            
            } else if ecgInfo.qrsType == PVC {
                
                itemIndex = 4
        
            } else if ecgInfo.qrsType == SVPB {
                
                itemIndex = 3
            
            } else if ecgInfo.qrsType == NORMAL {
                    
                
            }
        }
    }
    
    /// 列表中的序号
    var itemIndex = -1
    
    /// 类型列表
    private lazy var datas: [String] = {
        
        let data = [
            "Atrial fibrillation",
            "Ventricular flutter",
            "Atrial escape",
            "Atrial premature beats",
            "Ventricular premature beats",
            "Ventricular escape",
            "junction premature beats",
            "junction escape",
            "left bundle branch block",
            "Right bundle branch block",
        ]

        return data
        
    }()
    
    /// 网页内容
    private lazy var showWebContent: [String] = [
        
        "fangchan.html",
        "xinshipudong.html",
        "fangxingyibo.html",
        "fangxingzaobo.html",
        "shixingzaobo.html",
        "shixingyibo.html",
        "jiaojiexingzaobo.html",
        "jiaojiexingyibo.html",
        "zuoshuzhichuandaozuzhi.html",
        "youshuzhichuandaozuzhi.html"
    ]
    
    
    @IBOutlet weak var mainTilteView: UIView!
    
    @IBOutlet weak var diseaseLabel: UILabel!
    
    
    /// 类型列表
    @IBOutlet weak var listView: UITableView!
    
    
    
    /// 显示行高
    static var rowHeight: CGFloat {
        
        /// 行高 = 标题 + 间距 + 10个有效长度
        let height: CGFloat =
            64 + 30 + 10 * 44
         
        
        return height
    }

 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
         
        
        diseaseLabel.text = "Searching for disease"
        
        listView.rowHeight = 44
        listView.isScrollEnabled = false
        listView.showsVerticalScrollIndicator = false
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - 点击目录
extension YCECGDiseaseScreeningViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // load html 
         
    }
}

// MARK: - 显示数据
extension YCECGDiseaseScreeningViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier =
            "AI_DISEASE_SCREENING_CELL"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
            
            cell?.selectionStyle = .none
            
            cell?.imageView?.image =
                UIImage(named: "ai_ecg_report_cicle_point")
        }
        
        // 后缀
        let suffix =
            (itemIndex == indexPath.row) ? "Suspected" : "None"
        
        
        // 分组
        let item = datas[indexPath.row] + ": "
        
        
        let showString = NSMutableAttributedString(string: item, attributes: [
            
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0),
            NSAttributedString.Key.foregroundColor:
                UIColor(red: 45.0/255.0, green: 70.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        ])
         
        // 后缀
        let suffixString =
            NSMutableAttributedString(
                string: suffix,
                attributes: [
                    
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0),
                    NSAttributedString.Key.foregroundColor:
                        UIColor(red: 34.0/255.0, green: 137.0/255.0, blue: 206.0/255.0, alpha: 1.0)
                ]
            )
        
        showString.append(suffixString)
        
        // 加下划线
        showString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: showString.length))
        
        showString.addAttribute(
            .underlineColor,
            value: UIColor(red: 45.0/255.0, green: 70.0/255.0, blue: 66.0/255.0, alpha: 1.0),
            range: NSRange(location: 0, length: showString.length))

        
        cell?.textLabel?.attributedText = showString
        
        return cell ?? UITableViewCell()
    }
     
}
