//
//  UserDataSourceManager.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/25.
//

import Foundation
import SwiftUI



class UserDataSourceManager {
    
    static let shared = UserDataSourceManager()
    /// 隐私数据
    var accessors : [Accessor] = [Accessor]()
    /// 网络数据
    var networks : [Network] = [Network]()
    /// App信息
    var appInfos: [AppInfo] = LocationPrivateFileManager.find()
    /// 记录所有appids
    var appBoundIds = Set<String>()
  
    /// 获取app信息
    static func appInfo(boundId: String)-> AppInfo? {
       return UserDataSourceManager.shared.appInfos.filter{$0.boundId == boundId}.first
    }
    
    /// 获取appName
    static func appName(boundId: String? = nil, accessor: Accessor? = nil)-> String {
        guard let boundId = boundId else {
            guard let accessor = accessor else {
                return ""
            }
            return self.appInfo(boundId: accessor.accessor!.identifier ?? "")?.name ?? ""
        }
        return self.appInfo(boundId: boundId)?.name ?? boundId
    }
    
    /// 获取appIconUrl
    static func appIconUrl(boundId: String? = nil, accessor: Accessor? = nil)-> String {
        guard let boundId = boundId else {
            guard let accessor = accessor else {
                return ""
            }
            return self.appInfo(boundId: accessor.accessor!.identifier ?? "")?.logoUrl ?? ""
        }
        return self.appInfo(boundId: boundId)?.logoUrl ?? ""
    }
    
    /// 获取图标信息
    static func findChartsData(dataSource: [Accessor], type: String = "" , onlyLastDay: Bool = false , interval: NSInteger = 60)-> [String : [CharsViewDataItem]] {
        
        guard let lastTimeStamp = dataSource.last?.timeStamp else {
            return [:]
        }
        
        let typeResult = dataSource.filter { item in  //同一天
            var enable = true
            if (type != "") {
                enable = item.category ?? "" == type
            }
            if (onlyLastDay) {
                enable = enable && PrivateDataModelTools.timeIsOnSameDay(time1String: lastTimeStamp, time2String: item.timeStamp!)
            }
            return enable
        };
        
        var firstTimeStamp = typeResult.first?.timeStamp
        
        if firstTimeStamp == nil {
            return [:]
        }
        
        
        var returnDict = [String:[CharsViewDataItem]]()
        for item in typeResult {
            var returnList = returnDict[item.category!]
            if returnList == nil {
                returnList = [CharsViewDataItem]()
            }
            
            UserDataSourceManager.shared.appBoundIds.insert(item.accessor?.identifier ?? "")
            
            let key =  PrivateDataModelTools.stringConvertDate(string: item.timeStamp!, resultFormart: "HH:mm")
            let currentInterval = PrivateDataModelTools.stringConvertTimeInterval(time1String: item.timeStamp!, time2String:firstTimeStamp)
            if Int(currentInterval) < interval {
                if let last = returnList!.last {
                    var item = CharsViewDataItem(key: key, orginType: item.category!)
                    item.value = last.value + 1
                    if let index = returnList!.firstIndex(where: {$0 == last}) {
                        returnList![index] = item
                    }
                } else {
                    returnList!.append(CharsViewDataItem(key: key, orginType: item.category!))
                }
            } else {
                firstTimeStamp = item.timeStamp
                returnList!.append(CharsViewDataItem(key: key,orginType: item.category!))
            }
            returnDict[item.category!] = returnList!;
        }
        
        return returnDict;
    }
    
    /// 针对app的所有请求
    func allDataSourceForApp() -> Array<PrivateDataForAppModel>{
        LocationPrivateFileManager.initializeData()
        
        var dict = Dictionary<String,[Accessor]>()
        for item in accessors {
            let key = item.accessor!.identifier!
            var list = (dict[key] != nil) ? dict[key]! : [Accessor]()
            list.append(item)
            dict[key] = list
        }
        
        var dict2 = Dictionary<String,[Network]>()
        for item in networks {
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
