//
//  YCSearchDeviceViewController.swift
//  SwiftDemo
//
//  Created by macos on 2021/11/19.
//

import UIKit
import YCProductSDK
import CoreBluetooth



class YCSearchDeviceViewController: UIViewController {

    /// 所有的设备
    private lazy var devices = [CBPeripheral]()
    
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        navigationItem.title = "设备列表"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(searchDevice))
        
        searchDevice()
    }
 
     
    /// 搜索设备
    @objc private func searchDevice() {
        
        YCProduct.scanningDevice { devices, error in
            
            self.devices = devices
            self.listView.reloadData()
        }
    }

}

extension YCSearchDeviceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let device = devices[indexPath.row]
        
        YCProduct.connectDevice(device) { state, error in
            
            if state == .connected {
                
                self.navigationController?.popViewController(animated: true)
            }
             
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        
        if cell == nil {
            
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: String(describing: UITableViewCell.self))
            
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        }
        
        let device = devices[indexPath.row]
        
        cell?.textLabel?.text = device.name
        cell?.detailTextLabel?.text = " mac: \(device.macAddress.uppercased()), \t rssi:\(device.rssiValue)"
        
        return cell!
    }
}
