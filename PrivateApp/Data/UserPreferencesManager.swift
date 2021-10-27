//
//  UserPreferencesManager.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/26.
//

import Foundation
import SwiftUI

class SortModel: ObservableObject {
    enum SortModelType {
        case name
        case locatioCount
        case none
    }
    @Published var sortByType : SortModelType = .none
    @Published var filterByName : String = ""
}

struct UserPreferencesManager {
    static let shared: UserPreferencesManager = UserPreferencesManager()
    var warringTimes: Int = 10
    @ObservedObject var sortModel = SortModel()
}
