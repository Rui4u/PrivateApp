//
//  UserPreferencesManager.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/26.
//

import Foundation
import SwiftUI

typealias SortType = SortModel.SortType
typealias SortByType = SortModel.SortByType

class SortModel: ObservableObject {
    enum SortType: String {
        case name = "名称"
        case locatioCount = "隐私访问数量"
        case none
    }
    
    enum SortByType: String {
        case up = "升序"
        case down = "降序"
    }
}

class PreferencesManager: ObservableObject {
    
    static let shared: PreferencesManager = {
        var manager = PreferencesManager()
        if let path = LocationPrivateFileManager.findFile().last?.path {
            manager.path = path
        }
        return manager
    }()
    /// 隐私数据
    var accessors : [Accessor] = [Accessor]()
    /// 网络数据
    var networks : [Network] = [Network]()
    /// App信息
    var appInfos: [AppInfo] = LocationPrivateFileManager.find()
    /// 记录所有appids
    var appBoundIds = Set<String>()
  
    var allBinddingPath = false
    /// 原始数组
    var ogrinList = [Any]()
    
    /// 历史本地文件
    @Published var fileHistory :[LocationFileData] = {
        let data = LocationPrivateFileManager.findFile()
        return data
    }()
    
    @Published var appListDataSource: [PrivateDataForAppModel] = []
    @Published var sortType : SortType = .name
    @Published var sortByType : SortByType = .up
    
    @Published var filterByName : String = ""
    @Published var warringTimes: Int = 10
    
    @Published var path: String = "" {
        didSet {
            fileHistory =  LocationPrivateFileManager.findFile()
        }
    }
    
    /// 获取app信息
    static func appInfo(bundleId: String)-> AppInfo? {
       return PreferencesManager.shared.appInfos.filter{$0.bundleId == bundleId}.first
    }
    
    /// 获取appName
    static func appName(boundId: String? = nil, accessor: Accessor? = nil)-> String {
        
        if let boundId = boundId {
            return self.appInfo(bundleId: boundId)?.appName ?? boundId
        } else if let accessor = accessor {
           return self.appInfo(bundleId: accessor.accessor!.identifier ?? "")?.appName ?? ""
        }
        return ""
    }
    
    /// 获取appIconUrl
    static func appIconUrl(boundId: String? = nil, accessor: Accessor? = nil)-> String {
        guard let boundId = boundId else {
            guard let accessor = accessor else {
                return ""
            }
            return self.appInfo(bundleId: accessor.accessor!.identifier ?? "")?.artworkUrl100 ?? ""
        }
        return self.appInfo(bundleId: boundId)?.artworkUrl100 ?? ""
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
            
            PreferencesManager.shared.appBoundIds.insert(item.accessor?.identifier ?? "")
            
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
    func allDataSourceForApp(path: String?, complete: @escaping (Array<PrivateDataForAppModel>)->()) -> Void{
        guard let path = URL(string: path ?? "")else {
            complete([PrivateDataForAppModel]())
            return;
        }

        
        LocationPrivateFileManager.initializeData(path: path) { accessors, networks, orginList in
            self.ogrinList = orginList
            self.accessors = accessors
            self.networks = networks
            
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
            
            for key in dict.keys.sorted(by: {$0
                .localizedStandardCompare($1) == ComparisonResult.orderedAscending}) { //默认字符串排序
                let accessors = dict[key] ?? [Accessor]()
                let networks = dict2[key] ?? [Network]()
                let locationNums = accessors.count
                let netNums = networks.count
                
                let appInfo = PreferencesManager.shared.appInfos.filter{$0.bundleId == key}.first
                var model = PrivateDataForAppModel(accessors: accessors, networks: networks, boundID: key,netWorkNums: netNums,locationNums: locationNums)
                model.appInfo = appInfo
                result.append(model)
            }
            DispatchQueue.main.async {
                complete(result)
            }
        }
    }
}
