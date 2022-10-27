//
//  YCHealthDataViewController.swift
//  SwiftDemo
//
//  Created by macos on 2021/11/22.
//

import UIKit
import YCProductSDK

class YCHealthDataViewController: UIViewController {
    
    /// 设置选项
    private lazy var items = [
        
        "step",
        "sleep",
        "heartRate",
        "bloodPressure",
        "combinedData",
        
        // 以下为YC36定制使用
//        "bloodOxygen",
//        "temperatureHumidity",
//        "bodyTemperature",
//        "ambientLight",
//        "wearState",
//        "healthMonitoringData",
//        "sportModeHistoryData"
    ]
    
    
    /// 显示内容
    @IBOutlet weak var textView: UITextView!
    
    /// 列表
    @IBOutlet weak var listView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Health data"
        listView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableView.self))
    }
 

}

extension YCHealthDataViewController {
     
    
    /// 查询健康数据
    /// - Parameter index: <#index description#>
    func queryHealthData(_ index: NSInteger) {
        
        self.textView.text = ""
    
        switch index {
        case 0:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.step) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataStep] {
                    
                    var detail = "[ \n"
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    detail += "]"
                    
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 1:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.sleep) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataSleep] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 2:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.heartRate) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataHeartRate] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 3:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.bloodPressure) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataBloodPressure] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 4:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.combinedData) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataCombinedData] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 5:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.bloodOxygen) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataBloodOxygen] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 6:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.temperatureHumidity) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataTemperatureHumidity] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 7:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.bodyTemperature) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataBodyTemperature] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 8:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.ambientLight) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataAmbientLight] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
                
            }
            
        case 9:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.wearState) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataWearStateHistory] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 10:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.healthMonitoringData) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataMonitor] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        case 11:
            YCProduct.queryHealthData(dataType: YCQueryHealthDataType.sportModeHistoryData) { state, response in
                    
                if state == .succeed, let datas = response as? [YCHealthDataSportModeHistory] {
                    
                    var detail = "[ \n"
                    
                    for info in datas {
                        detail += info.toString
                        detail += "\n"
                    }
                    
                    detail += "]"
                    self.textView.text = detail
                    
                } else {
                    
                    self.showState(state)
                }
            }
            
        default:
            break
        }
    }
    
    /// 删除数据
    func deleteHealthData(_ index: NSInteger) {
        
        switch index {
        case 0:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.step) { state, response in
                
                self.showState(state)
            }
            
        case 1:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.sleep) { state, response in
                
                self.showState(state)
            }
            
        case 2:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.heartRate) { state, response in
                
                self.showState(state)
            }
            
        case 3:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.bloodPressure) { state, response in
                
                self.showState(state)
            }
            
        case 4:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.combinedData) { state, response in
                
                self.showState(state)
            }
            
        case 5:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.bloodOxygen) { state, response in
                
                self.showState(state)
            }
            
        case 6:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.temperatureHumidity) { state, response in
                
                self.showState(state)
            }
            
        case 7:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.bodyTemperature) { state, response in
                
                self.showState(state)
            }
            
        case 8:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.ambientLight) { state, response in
                
                self.showState(state)
            }
            
        case 9:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.wearState) { state, response in
                
                self.showState(state)
            }
            
        case 10:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.healthMonitoringData) { state, response in
                
                self.showState(state)
            }
            
        case 11:
            YCProduct.deleteHealthData(dataType: YCDeleteHealthDataType.sportModeHistoryData) { state, response in
                
                self.showState(state)
            }
            
        default:
            break
        }
    }
}

extension YCHealthDataViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            queryHealthData(indexPath.row)
        } else {
            deleteHealthData(indexPath.row)
        }
         
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let items = YCProduct.shared.currentPeripheral?.supportItems else {
            
            return 0
        }
        
        if indexPath.row == 0,
           items.isSupportStep != true {
            
            return 0
        
        } else if indexPath.row == 1,
                  items.isSupportSleep != true {
                   
            return 0
        
        } else if indexPath.row == 2,
                  items.isSupportHeartRate != true {
                   
            return 0
            
        } else if indexPath.row == 3,
                  items.isSupportBloodPressure != true {
                   
            return 0
            
        } else if indexPath.row == 4,
         (items.isSupportBloodOxygen == false &&
          items.isSupportRespirationRate == false &&
          items.isSupportTemperature == false) {
                   
            return 0
        }
        
        return 49
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Query"
        }
        
        return "Delete"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableView.self), for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.section + 1).\(indexPath.row + 1) " + items[indexPath.row]
        
        
        // 查询部分
        if indexPath.row == 0 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportStep != true
       
        } else if indexPath.row == 1 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportSleep != true
       
        } else if indexPath.row == 2 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportStep != true
       
        } else if indexPath.row == 0 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportStep != true
       
        } else if indexPath.row == 1 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportSleep != true
       
        } else if indexPath.row == 2 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportHeartRate != true
       
        } else if indexPath.row == 3 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodPressure != true
       
        } else if indexPath.row == 4 {
            
            cell.isHidden = YCProduct.shared.currentPeripheral?.supportItems.isSupportBloodOxygen != true &&
            
            YCProduct.shared.currentPeripheral?.supportItems.isSupportRespirationRate != true
             
            YCProduct.shared.currentPeripheral?.supportItems.isSupportTemperature != true
        }
        
        return cell
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func numberOfSections(in: UITableView) -> Int {
        return 2
    }
}

