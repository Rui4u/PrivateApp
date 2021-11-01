//
//  PrivateAppApp.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/19.
//

import SwiftUI

@main
struct PrivateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appDataSourceManager = PreferencesManager.shared
    var body: some Scene {
        WindowGroup {
            PrivateForAppPage().environmentObject(appDataSourceManager)
        }
    }
    
}
