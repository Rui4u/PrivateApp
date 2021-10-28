//
//  LocationPrivateFileManager.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/25.
//

import Foundation
import SwiftUI

struct LocationPrivateFileManager {
    
    static func saveAppInfo(appInfoList :[AppInfo]) {
        
        var array = [Dictionary<String,String>]()
        for item in appInfoList {
            array.append(item.tranformToDict())
        }
        
        let data = try? NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
        //获取documenth路径
        UserDefaults.standard.set(data, forKey: "appInfo")
    }
    
    static func find(key: String = "appInfo")-> [AppInfo] {
        //获取documenth路径
        if let result  = UserDefaults.standard.object(forKey: key) as? Data {
            let a = NSKeyedUnarchiver.unarchiveObject(with: result) as? [Dictionary<String, String>]
            var array = [AppInfo]()
            for item in a ?? [] {
                array.append(AppInfo.DictToModel(dict: item))
            }
            return array
        }
        return []
    }
    
    // MARK: - 初始化数据
    static func initializeData()  {
        
        var manager = UserDataSourceManager.shared
        
        var accessors : [Accessor] = [Accessor]()
        var networks : [Network] = [Network]()
        
        
        let path = Bundle.main.url(forResource: "App_Privacy_Report_v4_2021-10-28T17_21_59(1)", withExtension: "ndjson")!
        guard let iter = try? LineIterator(url: path) else {return}
        for line in iter {
            let jsondata = line.data(using: .utf8)
            guard let jsonObject =  try? JSONSerialization.jsonObject(with: jsondata!, options: .mutableContainers) as? [String: Any] else {return}
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
                
                if jsonObject["domain"] != nil {
                    if let product = try? JSONDecoder().decode(Network.self, from: jsonData) {
                        networks.append(product)
                    }
                }else if let product = try? JSONDecoder().decode(Accessor.self, from: jsonData) {
                    
                    var ischange = false;
                    accessors = accessors.map { item in
                        var item = item
                        if (item.identifier == product.identifier) {
                            item.endTimeStamp = product.timeStamp;
                            ischange = true;
                        }
                        return item
                    }
                    if !ischange {
                        accessors.append(product)
                    }
                }
            }
        }
        manager.accessors = accessors
        manager.networks = networks
    }
    
    // MARK: - Implementation
    class LineIterator: Sequence, IteratorProtocol {
        
        typealias Element = String
        
        let encoding: String.Encoding
        let chunkSize: Int
        let fileHandle: FileHandle
        let delimPattern: Data
        var buffer: Data
        var isAtEOF: Bool = false
        
        init(url: URL, delimeter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) throws
        {
            self.fileHandle = try FileHandle(forReadingFrom: url)
            self.chunkSize = chunkSize
            self.encoding = encoding
            buffer = Data(capacity: chunkSize)
            delimPattern = delimeter.data(using: .utf8)!
        }
        
        deinit {
            fileHandle.closeFile()
        }
        
        func makeIterator() -> LineIterator {
            fileHandle.seek(toFileOffset: 0)
            buffer.removeAll(keepingCapacity: true)
            isAtEOF = false
            return self
        }
        
        func next() -> Element? {
            if isAtEOF { return nil }
            
            repeat {
                if let range = buffer.range(of: delimPattern, options: [], in: buffer.startIndex..<buffer.endIndex) {
                    let subData = buffer.subdata(in: buffer.startIndex..<range.lowerBound)
                    let line = String(data: subData, encoding: encoding)
                    buffer.replaceSubrange(buffer.startIndex..<range.upperBound, with: [])
                    return line
                } else {
                    let tempData = fileHandle.readData(ofLength: chunkSize)
                    if tempData.count == 0 {
                        isAtEOF = true
                        return (buffer.count > 0) ? String(data: buffer, encoding: encoding) : nil
                    }
                    buffer.append(tempData)
                }
            } while true
        }
        
    }
}
