//
//  Request.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/25.
//

import Foundation
import Moya
//@available(iOS 15.0.0, *)

enum ItunesTarget {
    case lookup(bundleId:String)
}
extension ItunesTarget : TargetType {
    var baseURL: URL {
        return  URL(string: "https://itunes.apple.com/")!
    }
    
    var path: String {
        switch self {
        case .lookup(_):
            return "lookup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .lookup(_):
            return  .get
        }
    }
    
    public var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {

        case .lookup(let bundleId):
            parmeters = ["bundleId":bundleId] as [String : Any]
            parmeters["country"] = "cn"
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    // 是否执行Alamofire验证
     public var validate: Bool {
         return false
     }
    
    
}
class Request {
    
    /// 基本使用
    func loadData(boundId: String) {
        let NetworkProvider = MoyaProvider<ItunesTarget>()

        NetworkProvider.request(ItunesTarget.lookup(bundleId: boundId)) { result in
            if case .success(let response) = result {
                // 解析数据
                if let dic = try? response.mapJSON() as? NSDictionary {
                    print(dic)
                    let results = dic["results"] as? Array<Dictionary<String, Any>>
                    let result = results?.first                    
                    if var appInfo = AppInfo.deserialize(from: result) {
                        appInfo.isRequested = boundId.count > 0
                        PreferencesManager.shared.appInfos.append(appInfo)
                        LocationPrivateFileManager.saveAppInfo(appInfoList: PreferencesManager.shared.appInfos)
                    }
                }
                
            }
        }
    }
}
