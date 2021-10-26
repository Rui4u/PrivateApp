//
//  UserPreferencesManager.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/26.
//

import Foundation
struct UserPreferencesManager {
    static let shared: UserPreferencesManager = UserPreferencesManager()
    var warringTimes: Int = 10
}
