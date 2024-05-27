//
//  FirebaseChatAppApp.swift
//  FirebaseChatApp
//
//  Created by 홍승표 on 5/21/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FirebaseChatAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var fm = FirebaseManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fm)
        }
    }
}
