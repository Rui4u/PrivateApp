//
//  TestDataManager.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/28.
//

import Foundation
struct TestDataMangaer {
    static func accessor() -> Accessor {
        return Accessor(accessor: Accessor.AccessorItem(identifier: "com.alipay.iphoneclient", identifierType: "bundleID"), category: "location", kind: "intervalBegin", timeStamp: "2021-10-12T17:36:58.463+08:00", type: "access", identifier: "171A7620-22B8-463D-A3CD-5509DC62CE9A", endTimeStamp: "")
    }
    
    static func accessors() -> [Accessor] {
        return [self.accessor()]
    }
}
