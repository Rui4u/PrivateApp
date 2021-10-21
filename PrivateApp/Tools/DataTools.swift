//
//  DataTools.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import SwiftUI
struct PrivateDataModelTools {
    static func conversionEnglishToChinese(_ string: String?) -> String {
        guard let string = string else {
            return ""
        }
        if string == "location" {
            return "位置"
        }
        
        if string == "intervalBegin" {
            return "时间开始"
        }
        
        if string == "intervalEnd" {
            return "时间结束"
        }
        
        if string == "access" {
            return "访问"
        }
        if string == "photos" {
            return "相册"
        }
        
        if string == "camera" {
            return "相机"
        }
        return string
    }
    
    static func subiconForHeadIcon(type: String) -> Image {
        if type == "location" {
            return Image(systemName: "location.fill")
        }
        
        if type == "photos" {
            return Image(systemName: "photo.on.rectangle")
        }
        
        if type == "camera" {
            return Image(systemName: "camera")
            
        }
        return Image(systemName: "1")
    }
 
    
    static func stringConvertDate(string:String, resultFormart:String, dateFormat:String="yyyy-MM-dd'T'HH:mm:ss.SSSxxx") -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        formatter.dateFormat = resultFormart
        let str = formatter.string(from: date!)
        return str
    }
    
    static func stringConvertTimeInterval(time1String:String?,time2String: String?, dateFormat:String="yyyy-MM-dd'T'HH:mm:ss.SSSxxx") -> Double {
        guard let time1String = time1String else {
            return 0
        }
        guard let time2String = time2String else {
            return 0
        }

        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: time1String)
        let timeInterval = date?.timeIntervalSince1970 ?? 0
        
        let date2 = formatter.date(from: time2String)
        let timeInterval2 = date2?.timeIntervalSince1970 ?? 0
        
        let result = (timeInterval - timeInterval2)
        return result
     }
    
}
