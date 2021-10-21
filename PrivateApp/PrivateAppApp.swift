//
//  PrivateAppApp.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/19.
//

import SwiftUI

@main
struct PrivateAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PrivateForAppPage()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
