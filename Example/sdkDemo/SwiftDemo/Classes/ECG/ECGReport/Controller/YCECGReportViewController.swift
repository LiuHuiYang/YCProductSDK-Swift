//
//  YCECGReportViewController.swift
//  SmartHealthPro
//
//  Created by yc on 2020/11/26.
//  Copyright © 2020 yc. All rights reserved.
//

import UIKit
import YCProductSDK

/// 头部视图行高
private let HEADER_HEIGHT: CGFloat = 280

private let ecgResultCellIdentifier = "YCECGResultViewCell"
private let ecgPhotoCellIdentifier = "YCECGPhotoViewCell"
private let ecgDiseaseScreeningCellIdentifier =
    "YCECGDiseaseScreeningViewCell"


class YCECGReportViewController: UIViewController {

    /// ECG的数据信息
    var ecgInfo = YCHealthLocalECGInfo()
    
    
    /// 显示 ecg图片
    var ecgPicture:UIImage?
    
    /// 出错文字提示
    @IBOutlet weak var errorLabel: UILabel!
    
    /// 出错报告
    @IBOutlet weak var errorView: UIView!
    
    /// 报告列表
    @IBOutlet weak var listView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listView.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }


    /// 设置UI
    private func setupUI() {
        
        navigationItem.title = "Report of ECG AI"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .done, target: self, action: #selector(showECGDatas))
        
        errorView.isHidden = (ecgInfo.qrsType != NOISE)
        
        errorLabel.text = "This measurement signal is not good, which may caused by dry-skin. Please clean or moisten the skin and retest. Keep quiet during the test."
        
        setupListView()
        setupPhotoView()
    }
    
    /// 显示ECG数据
    @objc private func showECGDatas() {
        
        let vc = YCECGShowViewController()
        vc.ecgInfo = ecgInfo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 设置图片
    private func setupPhotoView() {
        
        let photoView = YCECGReportPictureView()
          
        photoView.drawEcgPoto(ecgInfo.ecgDatas) { [weak self] (image) in

            self?.ecgPicture = image
            self?.listView.reloadRows(
                at: [IndexPath(row: 1, section: 0)],
                with: .fade
            )
        }
    }
    
    /// 设置列表
    private func setupListView() {
        
        setupHeaderView()
       
        listView.register(
            UINib(nibName: ecgResultCellIdentifier, bundle: nil),
            forCellReuseIdentifier: ecgResultCellIdentifier
        )
        
        listView.register(
            UINib(nibName: ecgPhotoCellIdentifier, bundle: nil),
            forCellReuseIdentifier: ecgPhotoCellIdentifier
        )
        
        listView.register(
            UINib(nibName: ecgDiseaseScreeningCellIdentifier, bundle: nil),
            forCellReuseIdentifier: ecgDiseaseScreeningCellIdentifier
        )
    }

}
 


// MARK: - 代理
extension YCECGReportViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if 0 == indexPath.row {
            
            return YCECGResultViewCell.rowHeight
        
        } else if 1 == indexPath.row {
            
            return YCECGPhotoViewCell.rowHeight
            
        } else if 2 == indexPath.row {
        
            return YCECGDiseaseScreeningViewCell.rowHeight
        }
        
        return 0
    }
}

// MARK: - 显示报告的每个部分
extension YCECGReportViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if 0 == indexPath.row {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ecgResultCellIdentifier, for: indexPath) as? YCECGResultViewCell else {
                
                return UITableViewCell()
            }
            
            cell.ecgInfo = ecgInfo
            
            return cell
        
        } else if 1 == indexPath.row {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ecgPhotoCellIdentifier, for: indexPath) as? YCECGPhotoViewCell else {
                
                return UITableViewCell()
            }
            
            cell.ecgInfo = ecgInfo
            cell.ecgPicture = ecgPicture
            
            return cell
            
        } else if 2 == indexPath.row {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ecgDiseaseScreeningCellIdentifier, for: indexPath) as? YCECGDiseaseScreeningViewCell else {
                
                return UITableViewCell()
            }
            
            cell.ecgInfo = ecgInfo
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    
}


// 头部视图
extension YCECGReportViewController {
    
    private func setupHeaderView() {
        
        let iconView =
            UIImageView(image: UIImage(named: "report_head_en"))
        
        iconView.contentMode = .scaleAspectFit
        
        iconView.frame =
            CGRect(x: 20,
                   y: 0,
                   width: SCREEN_WIDTH - 2 * 20,
                   height: HEADER_HEIGHT
            )
        
        let headerView =
            UIView(frame:
                    CGRect(x: 0, y: 0, width: 0, height: HEADER_HEIGHT)
            )
        
        headerView.addSubview(iconView)
        
        listView.tableHeaderView = headerView
        
    }
}
