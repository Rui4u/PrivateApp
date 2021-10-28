//
//  UserPreferencesManager.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/26.
//

import Foundation
import SwiftUI

typealias SortType = SortModel.SortType
typealias SortByType = SortModel.SortByType

class SortModel: ObservableObject {
    enum SortType: String {
        case name = "名称"
        case locatioCount = "隐私访问数量"
        case none
    }
    
    enum SortByType: String {
        case up = "升序"
        case down = "降序"
    }
    
    @Published var sortType : SortType = .name
    @Published var filterByName : String = ""
    @Published var sortByType : SortByType = .up
}

class UserPreferencesManager {
    static let shared: UserPreferencesManager = UserPreferencesManager(warringTimes: "10")
    @State var warringTimes: String
    @ObservedObject var sortModel = SortModel()
    init(warringTimes: String) {
        self.warringTimes = warringTimes
    }
}
