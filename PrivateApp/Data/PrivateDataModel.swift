//
//  PrivateDataModel.swift
//  CalculatorApp
//
//  Created by sharui on 2021/10/18.
//

import UIKit
import Foundation
import SwiftUI



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

struct LocationPrivateFileManager {
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


    // MARK: - Usage

    
   static func searchLocationData() ->UserDataSourceManager {
        
        var manager = UserDataSourceManager.shared
       
        var accessors : [Accessor] = [Accessor]()
        var networks : [Network] = [Network]()
       
        
        let path = Bundle.main.url(forResource: "App_Privacy_Report_v4_2021-10-18T15_51_10", withExtension: "ndjson")!
        guard let iter = try? LineIterator(url: path) else {return manager}
        for line in iter {
            print(line)
            let jsondata = line.data(using: .utf8)
            guard let jsonObject =  try? JSONSerialization.jsonObject(with: jsondata!, options: .mutableContainers) as? [String: Any] else {return manager}
            
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
        return manager
    }
}




//{"domain":"117.161.74.49","firstTimeStamp":"2021-10-14T08:24:53.092+08:00","context":"","timeStamp":"2021-10-18T08:42:46.449+08:00","domainType":2,"initiatedType":"AppInitiated","hits":2,"type":"networkActivity","domainOwner":"","bundleID":"com.ss.iphone.ugc.Aweme"}
