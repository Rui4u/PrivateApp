//
//  DataTools.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import SwiftUI

typealias PrivateType = PrivateDataModelTools.LocationType

struct PrivateDataModelTools {
    struct IconInfo {
        var permissionsIconString: String
        var permissionsIconForegroundColor: Color
        var orginName: String
        var lineColor: Color
        
        private var _name :String?
        var name: String? {
            set {
                _name = newValue
            }
            get {
                guard let _name = _name else {
                    return orginName
                }
                return _name
            }
        }
        
        init(permissionsIconString : String, permissionsIconForegroundColor: Color, name: String? = nil, orginName:String, lineColor: Color) {
            self.permissionsIconString = permissionsIconString
            self.permissionsIconForegroundColor = permissionsIconForegroundColor
            self.lineColor = lineColor
            self.orginName = orginName
            
            self.name = name
        }
    }
    
    enum LocationType: String {
        case location = "location"
        case photos = "photos"
        case camera = "camera"
        case microphone = "microphone"
        case none
        
        static func iconInfo(rawValue: String) -> IconInfo {
            let type = LocationType(rawValue: rawValue)
            guard let type = type else {
                return LocationType.none.iconInfo()
            }

            return type.iconInfo()
        }
        
        private func iconInfo() -> IconInfo {
            switch self {
            case .location:
                return IconInfo(permissionsIconString: "location.fill", permissionsIconForegroundColor:.blue ,name: "定位", orginName: self.rawValue, lineColor: .blue)
            case .photos:
                return IconInfo(permissionsIconString: "photo.on.rectangle", permissionsIconForegroundColor:.green ,name: "相册", orginName: self.rawValue, lineColor: .green)
            case .camera:
                return IconInfo(permissionsIconString: "camera", permissionsIconForegroundColor:.black ,name: "照相机", orginName: self.rawValue, lineColor: .black)
            case .microphone:
                return IconInfo(permissionsIconString: "mic", permissionsIconForegroundColor:.orange ,name: "麦克风", orginName: self.rawValue, lineColor: .orange)
            case .none:
                return IconInfo(permissionsIconString: "square.and.arrow.up.circle", permissionsIconForegroundColor:.orange, orginName: self.rawValue, lineColor: .orange)
            }
        }
    }

    static func conversionEnglishToChinese(_ string: String?) -> String {
        guard let string = string else {
            return ""
        }
        if string == "intervalBegin" {
            return "时间开始"
        }
        
        if string == "intervalEnd" {
            return "时间结束"
        }
        return string
    }
  
    
    static func stringConvertDate(string:String?, resultFormart:String, dateFormat:String="yyyy-MM-dd'T'HH:mm:ss.SSSxxx") -> String {
        guard let string = string else {
            return ""
        }
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
    
    
    /// 是否为同一天
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
