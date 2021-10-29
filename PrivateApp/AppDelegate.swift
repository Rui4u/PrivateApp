//
//  AppDelegate.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/29.
//

import Foundation
import UIKit
import Combine

class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject { // 👈🏻
  
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        let path = Bundle.main.url(forResource: "App_Privacy_Report_v4_2021-10-28T17_21_59(1)", withExtension: "ndjson")!
        guard let url = URLContexts.first?.url.absoluteString else {
            return
        }
        UserDataSourceManager.shared.path = url
        
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }

    /// 设置secneDelegate
    func application( _ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
       sceneConfig.delegateClass = SceneDelegate.self // 👈🏻
       return sceneConfig
     }
}
