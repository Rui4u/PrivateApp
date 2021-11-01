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
        guard let url = URLContexts.first?.url.absoluteString else {
            return
        }
        PreferencesManager.shared.path = url
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
