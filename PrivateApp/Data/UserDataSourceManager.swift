//
//  UserDataSourceManager.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/25.
//

import Foundation

struct UserDataSourceManager {
    
    static var shared = UserDataSourceManager()
    var accessors : [Accessor] = [Accessor]()
    var networks : [Network] = [Network]()
    var appInfos: [AppInfo] = LocationPrivateFileManager.find()
    var appBoundIds = Set<String>()
    
    static func appInfo(boundId: String)-> AppInfo? {
       return UserDataSourceManager.shared.appInfos.filter{$0.boundId == boundId}.first
    }
    
    static func appName(boundId: String? = nil, accessor: Accessor? = nil)-> String {
        guard let boundId = boundId else {
            guard let accessor = accessor else {
                return ""
            }
            return self.appInfo(boundId: accessor.accessor!.identifier ?? "")?.name ?? ""
        }
        return self.appInfo(boundId: boundId)?.name ?? boundId
    }
    
    static func appIconUrl(boundId: String? = nil, accessor: Accessor? = nil)-> String {
        guard let boundId = boundId else {
            guard let accessor = accessor else {
                return ""
            }
            return self.appInfo(boundId: accessor.accessor!.identifier ?? "")?.logoUrl ?? ""
        }
        return self.appInfo(boundId: boundId)?.logoUrl ?? ""
    }
    
    
    static func findCharsData(dataSource: [Accessor], type: String = "" , onlyLastDay: Bool = false , interval: NSInteger = 60)-> [String : [CharsViewDataItem]] {
        
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
    
}
