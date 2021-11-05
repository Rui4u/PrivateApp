//
//  LocationPrivateFileManager.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/25.
//

import Foundation
import SwiftUI
import HandyJSON


struct LocationPrivateFileManager {
    
    static func saveAppInfo(appInfoList :[AppInfo]) {
        
        var array = [String]()
        for item in appInfoList {
            array.append(item.toJSONString() ?? "")
        }
        
        let data = try? NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
        //获取documenth路径
        UserDefaults.standard.set(data, forKey: "appInfo")
    }
    
    
    static func find(key: String = "appInfo")-> [AppInfo] {
        //获取documenth路径
        if let result  = UserDefaults.standard.object(forKey: key) as? Data {
            let a = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: NSString.self, from: result)
            var array = [AppInfo]()
            for item in a ?? [] {
                if let app = AppInfo.deserialize(from: item as String) {
                    array.append(app)
                }
            }
            return array
        }
        return []
    }
    
    static func deleteLocationFile(path: String){
        let fileManager = FileManager.default
//        if fileManager.isDeletableFile(atPath: path) {
            let _ = try? fileManager.removeItem(atPath: path)
            PreferencesManager.shared.fileHistory = LocationPrivateFileManager.findFile()
//        }
    }
    
    
    
    static let customPath = "ndjson"
    
    static func findFile() -> [LocationFileData]{
        var resultList = [LocationFileData]()
        
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else {
            return resultList
        }
        
        guard let pathUrl = URL(string:path)?.appendingPathComponent(customPath).absoluteString else {
            return resultList
        }
        
        guard let bundlePath = Bundle(path: pathUrl)?.resourcePath else {
            return resultList
        }
        let array = Bundle.paths(forResourcesOfType: "ndjson", inDirectory: bundlePath).sorted {$0.localizedStandardCompare($1) == .orderedAscending}
        
        
        for item in array {
            if let url = URL(string: item) {
                resultList.append(LocationFileData(name: url.lastPathComponent, path: url.absoluteString))
            }
        }
        return resultList
    }
    
    static func saveFile(url: URL) -> String {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else {
            return ""
        }
        let fileManager = FileManager.default
        
        let fileName = "\(url.lastPathComponent)"
        let fileDictUrl = URL(fileURLWithPath:path).appendingPathComponent(customPath)
        
        do {
            try fileManager.createDirectory(at: fileDictUrl, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error)
        }
        
        let filePath = URL(string: path)!.appendingPathComponent(customPath).appendingPathComponent(fileName).absoluteString
        
        if (fileManager.fileExists(atPath: filePath)) { // 如果文件存在 删除就文件
           try? fileManager.removeItem(atPath: filePath)
        }
        
        guard let data = NSData(contentsOf: url) else {
            return ""
        }
        let _ = data.write(toFile: filePath, atomically: true)
        return filePath
    }
    
       
    // MARK: - 初始化数据
    static func initializeData(path url: URL, complete: @escaping ([Accessor], [Network], [Any] )->()) -> Void {
        DispatchQueue.global().async {
            var accessors : [Accessor] = [Accessor]()
            var networks : [Network] = [Network]()
            var orginList : [Any] = [Any]()

            guard let path = url as URL? else { return }
            guard let iter = try? LineIterator(url: path) else {return}
            for line in iter {
                let jsondata = line.data(using: .utf8)
                guard let jsonObject =  try? JSONSerialization.jsonObject(with: jsondata!, options: .mutableContainers) as? [String: Any] else {return}

                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {

                    if jsonObject["domain"] != nil {
                        if let product = try? JSONDecoder().decode(Network.self, from: jsonData) {
                            networks.append(product)
                            orginList.append(product)
                        }
                    } else if let product = try? JSONDecoder().decode(Accessor.self, from: jsonData) {

                        orginList.append(product)
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
            complete(accessors, networks,orginList)
        }
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
