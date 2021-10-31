//
//  PrivateDataModel.swift
//  CalculatorApp
//
//  Created by sharui on 2021/10/18.
//

import UIKit
import Foundation
import SwiftUI
import HandyJSON


struct BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!
}

struct AppInfo :HandyJSON, Hashable{
    var name: String?
    var logoUrl: String?
    var boundId: String?
    var isRequested: Bool = false
}

struct Accessor: Decodable, Encodable, Hashable {
    struct AccessorItem: Decodable, Encodable, Hashable{
        var identifier: String?
        var identifierType: String?
    }
    
    var accessor: AccessorItem?
    var category: String?
    //intervalBegin  intervalEnd
    var kind: String?
    var timeStamp: String?
    var type: String?   //type
    var identifier: String?
    // 自定义
    /// 结束时间
    var endTimeStamp: String?
    /// 是否有时间区间
    var haveTimeRange: Bool {
        return  endTimeStamp?.count ?? 0 > 0
    }
}

struct Network: Decodable, Encodable, Hashable{
    var domain: String?
    var firstTimeStamp: String?
    var context: String?
    var timeStamp: String?
    var domainType: Int64?
    var initiatedType: String?   //type
    var hits: Int64?
    var type: String?
    var domainOwner: String?
    var bundleID:String?
}

struct PrivateDataForAppModel: Hashable{
    var accessors : [Accessor] = [Accessor]()
    var networks : [Network] = [Network]()
    var boundID: String
    var netWorkNums: Int
    var locationNums: Int
}





//{"domain":"117.161.74.49","firstTimeStamp":"2021-10-14T08:24:53.092+08:00","context":"","timeStamp":"2021-10-18T08:42:46.449+08:00","domainType":2,"initiatedType":"AppInitiated","hits":2,"type":"networkActivity","domainOwner":"","bundleID":"com.ss.iphone.ugc.Aweme"}
