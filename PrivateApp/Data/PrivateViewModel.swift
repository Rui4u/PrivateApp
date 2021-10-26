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



