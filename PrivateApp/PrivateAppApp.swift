//
//  PrivateAppApp.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/19.
//

import SwiftUI

@main
struct PrivateAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appDataSourceManager = UserDataSourceManager.shared
    var body: some Scene {
        WindowGroup {
            PrivateForAppPage().environmentObject(appDataSourceManager)
        }
    }
    
}
