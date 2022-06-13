//
//  YCWatchFaceViewController.swift
//  SwiftDemo
//
//  Created by macos on 2021/11/30.
//

import UIKit
import YCProductSDK

class YCWatchFaceViewController: UIViewController {
    
    private lazy var dials = [YCWatchFaceInfo]()
    
    private lazy var items = [
        "Query dial",
        "Change dial",
        "Delete dial",
        "Download dial",
    ]
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var listView: UITableView!
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Watch face"
        
        // 监听表盘切换的通知
        // Listen for notifications of watch face switching
        NotificationCenter.default.addObserver(self, selector: #selector(watchFaceChanged(_:)), name: YCProduct.deviceControlNotification, object: nil)
        
        listView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }
    
    
    /// 查询设备中的表盘信息
    /// Query the watch face information in the device
    private func queryDeviceFaceInfo() {
        
        YCProduct.queryWatchFaceInfo { state, response in
            
            // 查询成功后，转换表具体的表盘类型
            // After the query is successful, convert the specific dial type of the table.
            if state == YCProductState.succeed,
               let info = response as? YCWatchFaceBreakCountInfo {
                
                /*
                 
                 /// Breakpoint information of the watch face
                 @objcMembers public class YCWatchFaceBreakCountInfo : NSObject {
                 
                 /// Dial data
                 public  var dials: [YCProductSDK.YCWatchFaceInfo] { get }
                 
                 /// Maximum number supported
                 public  var limitCount: Int { get }
                 
                 /// Locally stored quantity
                 public  var localCount: Int { get }
                 }
                 
                 
                 /// Dial information
                 @objcMembers public class YCWatchFaceInfo : NSObject {
                 
                 /// Dial id
                 public  var dialID: UInt32
                 
                 /// Dial breakpoint value
                 public  var blockCount: UInt16
                 
                 /// Support delete
                 public  var isSupportDelete: Bool { get }
                 
                 /// Dial version
                 public  var version: UInt16 { get }
                 
                 /// Whether it is a custom watch face
                 public  var isCustomDial: Bool { get }
                 
                 /// Whether it is the current display dial
                 public  var isShowing: Bool { get }
                 
                 }
                 
                 */
                
                // 显示表盘信息
                // Display watch face information
                if info.localCount > 0 {
                    
                    var detail = "[\n"
                    for item in info.dials {
                        
                        detail += item.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    
                    self.dials = info.dials
                    self.textView.text = detail
                }
                
            } else {
                
                self.showState(state)
            }
        }
    }
    
    
    /// 表盘切换 dial switch
    /// - Parameter ntf:
    @objc private func watchFaceChanged(_ ntf: Notification) {
        
        // 获取表盘变更的表盘id号
        // Get the dial id number of the dial change
        guard let info = ntf.userInfo,
              let dialID = ((info[YCDeviceControlType.switchWatchFace.string]) as? YCReceivedDeviceReportInfo)?.data as? UInt32  else {
                  return
              }
        
        self.textView.text = "changed: \(dialID)"
        
    }
    
}

// MARK: - 下载自定义表盘
extension YCWatchFaceViewController {
    
    
    /// 下载自定义表盘 (需要手表支持且提供自定义源文件)
    /// Download custom watch faces (requires watch support and custom source files)
    private func downloadCustomDial() {
        
        // 加载自定义源文件
        // Load custom source files
        guard let path = Bundle.main.path(forResource: "customE80.bin", ofType: nil),
              let dialData = NSData(contentsOfFile: path) else {
                  
                  return
              }
        
        // 表盘id在提供自定义表盘文件时会同时提供，注意不同手环的自定义表盘文件和表盘id是不相同的
        // The dial id will be provided at the same time when the custom dial file is provided. Note that the custom dial file and dial id of different bracelets are different.
        let dialID: UInt32 = 2147483539
        
        // 转换新的表盘文件，参数在文档中已经详细说明
        // 包含自定义表盘源文件，背景图片、缩略图、时间位置、文字颜色。
        // Convert a new watch face file, the parameters have been described in detail in the document, including the custom watch face source file, background image, thumbnail, time position, text color.
        
        /// - Parameters:
        ///   - dialData: Original dial data
        ///   - backgroundImage: Background picture
        ///   - thumbnail: Thumbnail
        ///   - timePosition: Time display position coordinates
        ///   - redColor: 0 ~ 255
        ///   - greenColor: 0 ~ 255
        ///   - blueColor: 0 ~ 255
        /// - Returns: Dial data
        let customDialData = YCProduct.generateCustomDialData(
            dialData as Data,
            backgroundImage: UIImage(named: "test"),
            thumbnail: UIImage(named: "test"),
            timePosition: CGPoint(x: 120, y: 120),
            redColor: 255,
            greenColor: 0,
            blueColor: 0,
            isFlipColor: YCProduct.shared.currentPeripheral?.supportItems.isFlipCustomDialColor ?? false
        ) as NSData
        
        
        // 避免出错，先删除相同的表盘
        // To avoid mistakes, delete the same watch face first
        YCProduct.deleteWatchFace(dialID: dialID) { state, response in
            
            // 下载表盘文件
            // Download the watch face file
            ///   - isEnable: On or off
            ///   - data: Dial data
            ///   - dialID: Dial ID
            ///   - blockCount: Dial breakpoint
            ///   - dialVersion: Dial version
            ///   - completion: Download progress
            YCProduct.downloadWatchFace(isEnable: true, data: customDialData, dialID: dialID, blockCount: 0, dialVersion: 1) { state, response in
                
                /*
                    下载信息 YCDownloadProgressInfo
                 
                 /// Download data progress information
                 @objcMembers public class YCDownloadProgressInfo : NSObject {
                 
                     /// Progress (0 ~ 1.0)
                     public  var progress: Float { get }
                 
                     /// Downloaded data size
                     public  var downloaded: Int
                 
                     /// The size of the total downloaded data
                     public  var total: Int { get }
                 }
                 
                 */
                
                if state == .succeed,
                   let info = response as? YCDownloadProgressInfo {
                    
                    self.textView.text = "downlaod: \(info.downloaded), \(Int(info.progress * 100))%"
                    
                } else {
                    
                    self.showState(state)
                }
            }
        }
        
    }
}

extension YCWatchFaceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.textView.text = ""
        
        switch indexPath.row {
        case 0:
            queryDeviceFaceInfo()
            
        case 1:
            
            // 切换表盘 dialID: 表盘ID
            // toggle watch face,  dialID: Dial ID
            if let info = self.dials.first {
                
                YCProduct.changeWatchFace(dialID: info.dialID) { state, response in
                    
                    self.showState(state)
                }
            }
            
        case 2:
            
            // 删除表盘 dialID: 表盘ID
            // delete watch face, dialID: Dial ID
            if let info = self.dials.last {
                
                YCProduct.deleteWatchFace(dialID: info.dialID) { state, response in
                    
                    self.showState(state)
                }
            }
            
        case 4:
            
            if YCProduct.shared.currentPeripheral?.supportItems.isSupportCustomWatchface == true {
                
                downloadCustomDial()
                
            } else {
                
                // download dial file
                //                YCProduct.downloadWatchFace(isEnable: true, data: <#T##NSData#>, dialID: <#T##UInt32#>, blockCount: <#T##UInt16#>, dialVersion: <#T##UInt16#>) { state, response in
                //                    <#code#>
                //                }
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
            
        } else if state == .noRecord {
            self.textView.text = "No data"
        } else if state == .failed {
            MBProgressHUD.wj_showError()
        }
    }
}

extension YCWatchFaceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
}

