//
//  DataLoader.swift
//  Olimp
//
//  Created by Филипп on 24.07.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import Foundation

class DataLoader {
    
    private var session: URLSession
    private let url = "https://revolut.duckdns.org/latest?base="
    
    init() {
        self.session = URLSession.shared
    }
    
    func getData(name: String,_ callback: @escaping (NSDictionary?) -> Void){
        
        let task = self.session.downloadTask(with: getUrl(name: name)){location, response, error in
            do{
                let data = try Data(contentsOf: self.getUrl(name: name))
                let dataJson = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                
                if error == nil{
                    callback(dataJson)
                }
                else{
                    callback(nil)
                }
            }
            catch{
                print("error")
                callback(nil)
            }
        }
        task.resume()
    }
    
    private func getUrl(name: String) -> URL{
        let newUrlStr = self.url + name
        return URL(string: newUrlStr)!
    }
    
}
