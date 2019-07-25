//
//  ConverterViewController.swift
//  Olimp
//
//  Created by Филипп on 24.07.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

class ConverterViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var itemButton: UIBarButtonItem!
    @IBAction func tapItemButton(_ sender: UIBarButtonItem) {
        itemButtonIsHidden(isHidden: true)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil,from:nil,for:nil)
    }
    let dataManager = DataManager()
    var besidesRow: Int?
    
    var timer: Timer?
    let timeIntervalUpdate = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTimer()
        itemButtonIsHidden(isHidden: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataManager.ratesDic.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell
        let name = self.dataManager.namesArr[indexPath.row]
        cell.nameLabel.text = name
        cell.valueField.text = String(self.dataManager.currenciesValueDic[name]!)
        cell.selectionStyle = .none
        cell.valueField.delegate = self
        cell.valueField.tag = indexPath.row
        if name == self.dataManager.euroName{
            cell.backgroundColor = UIColor(red: 234.0/255.0, green: 240.0/255.0, blue: 255.0/255.0, alpha: 1)
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    private func createTimer(){
        if self.timer == nil{
            self.timer = Timer.scheduledTimer(timeInterval: self.timeIntervalUpdate, target: self, selector: #selector(updateRatesDataDic), userInfo: nil, repeats: true)
            self.timer?.tolerance = 0.01
        }
    }
    
    @objc private func updateRatesDataDic(){
        dataManager.getDataDic { (isSuccess) in
            if isSuccess{
                self.reloadRows()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        itemButtonIsHidden(isHidden: false)
        self.besidesRow = textField.tag
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.besidesRow = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        euroUpdate(tag: textField.tag, text: updatedString)
        return true
    }

    private func itemButtonIsHidden(isHidden: Bool){
        if isHidden{
            self.itemButton.isEnabled = false
            self.itemButton.tintColor = UIColor.clear
        }
        else{
            self.itemButton.isEnabled = true
            self.itemButton.tintColor = nil
        }
    }
    
    private func euroUpdate(tag: Int, text: String?){
        let name = self.dataManager.namesArr[tag]
        var newValue: Float = 0.0
        if text != nil && text != ""{
            let val = Float(text!)
            if val != nil{
                newValue = val!
            }
            else{
                newValue = 0.0
            }
        }
        DispatchQueue.global().async {
            self.dataManager.setEuro(newValue: newValue, name: name) { (isSuccess) in
                if isSuccess{
                    self.reloadRows()
                }
            }
        }
    }
    
    private func reloadRows(){
        DispatchQueue.global().async {
            if self.besidesRow == nil{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            else{
                var arrIndexPath: [IndexPath] = []
                for i in 0...self.dataManager.currenciesValueDic.count - 1{
                    if i != self.besidesRow{
                        arrIndexPath.append(IndexPath(row: i, section: 0))
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: arrIndexPath, with: .none)
                }
            }
        }
        
    }
    
    
}
