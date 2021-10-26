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
 
    static func subiconForLineColor(type: String) -> Color {
        if type == "location" {
            return .blue
        }
        
        if type == "photos" {
            return .red
        }
        
        if type == "camera" {
            return .orange
            
        }
        
        if type == "microphone" {
            return .green
        }
        
        return .gray
    }
    
    static func stringConvertDate(string:String, resultFormart:String, dateFormat:String="yyyy-MM-dd'T'HH:mm:ss.SSSxxx") -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        formatter.dateFormat = resultFormart
        let str = formatter.string(from: date!)
        return str
    }
    
    /// 计算时间差   返回为秒
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
    
    
    /// 计算时间差   返回为秒
    static func timeIsOnSameDay(time1String:String?,time2String: String?, dateFormat:String="yyyy-MM-dd'T'HH:mm:ss.SSSxxx") -> Bool {
        
        guard let time1String = time1String else {
            return false
        }
        guard let time2String = time2String else {
            return false
        }

        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        
        guard let date = formatter.date(from: time1String) else {
            return false
        }
        
        guard let date2 = formatter.date(from: time2String) else {
            return false
        }
        
        if Calendar.current.isDate(date, inSameDayAs: date2) {
            return true;
        }else {
            return false
        }
     }
}
