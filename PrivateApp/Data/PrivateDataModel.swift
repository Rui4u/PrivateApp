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

struct AppInfo: HandyJSON ,Hashable {
    var screenshotUrls: Array<String>?
    var ipadScreenshotUrls: Array<String>?
    var appletvScreenshotUrls: Array<String>?
    var artworkUrl60: String?
    var artworkUrl512: String?
    var artworkUrl100: String?
    var artistViewUrl: String?
    var features: Array<String>?
    var supportedDevices: Array<String>?
    var advisories: Array<String>?
    var isGameCenterEnabled: Bool = false
    var kind: String?
    var averageUserRatingForCurrentVersion: Float = 0
    var userRatingCountForCurrentVersion: Int = 0
    var averageUserRating: Float = 0
    var trackViewUrl: String?
    var trackContentRating: String?
    var minimumOsVersion: String?
    var trackCensoredName: String?
    var languageCodesISO2A: Array<String>?
    var currency: String?
    var bundleId: String?
    var trackId: Int = 0
    var trackName: String?
    var releaseDate: String?
    var sellerName: String?
    var primaryGenreName: String?
    var genreIds: Array<String>?
    var formattedPrice: String?
    var isVppDeviceBasedLicensingEnabled: Bool = false
    var currentVersionReleaseDate: String?
    var releaseNotes: String?
    var primaryGenreId: Int = 0
    var description: String?
    var artistId: Int = 0
    var artistName: String?
    var genres: Array<String>?
    var price: Float = 0
    var version: String?
    var wrapperType: String?
    var userRatingCount: Int = 0
    
    
    // 自定义 负责记录
    var isRequested: Bool = false
    var appName: String? {
        trackName?.components(separatedBy: " ").first?.components(separatedBy: "-").first
    }
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
    var appInfo: AppInfo?
}

struct LocationFileData: Identifiable , Hashable{
    var id: Int {
        self.name.hashValue + self.path.hashValue
    }
    var name: String
    var path: String
}



//{"domain":"117.161.74.49","firstTimeStamp":"2021-10-14T08:24:53.092+08:00","context":"","timeStamp":"2021-10-18T08:42:46.449+08:00","domainType":2,"initiatedType":"AppInitiated","hits":2,"type":"networkActivity","domainOwner":"","bundleID":"com.ss.iphone.ugc.Aweme"}
