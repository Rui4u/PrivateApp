//
//  Request.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/25.
//

import Foundation

//@available(iOS 15.0.0, *)

class Request {
    
    func loadData(boundId: String) {
        guard UserDataSourceManager.shared.appInfos.filter({$0.boundId == boundId || $0.isRequested == false}).count == 0 else {
            return
        }
        
        let urlString = "https://itunes.apple.com/lookup?bundleId=" + boundId
        print(urlString)
        DispatchQueue.global().async {
         
            let url:URL = URL.init(string: urlString)!;
            
            let request:URLRequest = URLRequest(url: url)
            
            //NSURLSession 对象都由一个 NSURLSessionConfiguration 对象来进行初始化，后者指定了刚才提到的那些策略以及一些用来增强移动设备上性能的新选项
            
            let configuration:URLSessionConfiguration = URLSessionConfiguration.default
            
            let session:URLSession = URLSession.init(configuration: configuration);
            
            let task:URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
                
                
                if error == nil{
                    
                    do{
                        let dic:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary;
                        
                        print(dic)
                        var results = dic["results"] as? Array<Dictionary<String, Any>>
                        let result = results?.first
                        let iconUrl = result?["artworkUrl100"] as? String ?? ""
                        let name = result?["trackName"]  as? String ?? ""
                        let bundleId = result?["bundleId"]  as? String ?? ""
                        
                        var appInfo = AppInfo(name: name, logoUrl: iconUrl, boundId: boundId)
                        appInfo.isRequested = boundId.count > 0
                        UserDataSourceManager.shared.appInfos.append(appInfo)
                        LocationPrivateFileManager.saveAppInfo(appInfoList: UserDataSourceManager.shared.appInfos)
                        
                        
                    }catch{
                        
                        print("catch")
                        
                    }
                }else{
                    print(error?.localizedDescription ?? "请求有误")
                    
                }
            };
            task.resume();
            }
        }

}
