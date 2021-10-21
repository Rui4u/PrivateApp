//
//  PrivateViewModel.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import Foundation
import SwiftUI

struct PrivateViewModel {
    var allDataSource = LocationPrivateFileManager.searchLocationData()
 
    /// 针对app的所有请求
    func allDataSourceForApp() -> Array<PrivateDataForAppModel>{
        var dict = Dictionary<String,[Accessor]>()
        for item in allDataSource.accessors {
            let key = item.accessor!.identifier!
            var list = (dict[key] != nil) ? dict[key]! : [Accessor]()
            list.append(item)
            dict[key] = list
        }
        
        var dict2 = Dictionary<String,[Network]>()
        for item in allDataSource.networks {
            let key = item.bundleID!
            var list = (dict2[key] != nil) ? dict2[key]! : [Network]()
            list.append(item)
            dict2[key] = list
        }
        
        
        var result = [PrivateDataForAppModel]()
        for key in dict.keys {
            let accessors = dict[key] ?? [Accessor]()
            let networks = dict2[key] ?? [Network]()
            let locationNums = accessors.count
            let netNums = networks.count
            result.append(PrivateDataForAppModel(accessors: accessors, networks: networks, boundID: key,netWorkNums: netNums,locationNums: locationNums))
        }
        return result
    }
    
   
}

struct AppInfo {
    var name: String;
    var locationIconString: String;
}

struct UserDataSourceManager {
    let dict = ["com.lagou.lagouhr": AppInfo(name: "拉勾", locationIconString: "lagou_logo")]
    static let shared = UserDataSourceManager()
    var accessors : [Accessor] = [Accessor]()
    var networks : [Network] = [Network]()
    
    func appInfo(boundId: String)-> AppInfo? {
        guard let info = dict[boundId] else { return nil }
        return info;
    }
    
    
    static func findCharsData(interval: NSInteger, type: String, dataSource: [Accessor])-> [CharsViewDataItem] {
        let typeResult = dataSource.filter{$0.category ?? "" == type};
        var firstTimeStamp = typeResult.first?.timeStamp
        
        if firstTimeStamp == nil {
            return []
        }
        
        var returnList = [CharsViewDataItem]()
        for item in typeResult {
            let key =  PrivateDataModelTools .stringConvertDate(string: item.timeStamp!, resultFormart: "HH:mm")
            let currentInterval = PrivateDataModelTools.stringConvertTimeInterval(time1String: item.timeStamp!, time2String:firstTimeStamp )
            if Int(currentInterval) < interval {
                if let last = returnList.last {
                    var item = CharsViewDataItem(key: key, value:1)
                    item.value = last.value + 1
                    if let index = returnList.firstIndex(where: {$0 == last}) {
                        returnList[index] = item
                    }
                } else {
                    returnList.append(CharsViewDataItem(key: key, value: 1))
                }
            } else {
                firstTimeStamp = item.timeStamp
                returnList.append(CharsViewDataItem(key: key, value: 1))
            }
        }
        
        return returnList;
    }
}
