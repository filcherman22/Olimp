//
//  DataManager.swift
//  Olimp
//
//  Created by Филипп on 24.07.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import Foundation

class DataManager {
    
    private var dataLoader: DataLoader!
    
    var ratesDic: Dictionary<String, Float> = [:]
    var namesArr: [String] = []
    var currenciesValueDic: Dictionary<String, Float> = [:]
    
    var euroValue: Float = 1.0
    var euroName: String = "EUR"
    
    init() {
        self.dataLoader = DataLoader()
        getDataDic { (issuccess) in
            if issuccess{
                self.createData()
            }
        }
    }
    
    
    func getDataDic(_ callback: @escaping (Bool) -> Void){
        self.dataLoader.getData(name: self.euroName, { (dataDic) in
            if dataDic != nil{
                let newRates = self.getRatesDic(data: dataDic!)
                
                for el in newRates{
                    self.ratesDic[el.key] = el.value
                    self.currenciesValueDic[el.key] = self.euroValue * el.value
                }
                if self.namesArr.count == 0{
                    self.createData()
                }
                callback(true)
            }else{
                callback(false)
            }
        })
    }
    
    private func createData(){
        self.ratesDic[self.euroName] = 1.0
        self.currenciesValueDic[self.euroName] = self.euroValue
        for el in self.ratesDic{
            self.namesArr.append(el.key)
        }
    }
    
    func setEuro(newValue: Float, name: String, _ callback: @escaping (Bool) -> Void){
        self.euroValue = newValue
        if self.euroName != name{
            self.euroName = name
            self.currenciesValueDic[name] = newValue
            getDataDic { (isSucccess) in
                callback(isSucccess)
            }
        }
        else{
            self.ratesDic[name] = 1.0
            for el in self.ratesDic{
                currenciesValueDic[el.key] = self.euroValue * el.value
            }
            callback(true)
        }
        
    }
    
    private func getRatesDic(data: NSDictionary) -> Dictionary<String, Float>{
        let rates = data["rates"] as! NSDictionary
        var dataDic: Dictionary<String, Float> = [:]
        for el in rates{
            dataDic[el.key as! String] = (el.value as! NSNumber).floatValue
        }
        return dataDic
    }
}
