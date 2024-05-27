//
//  ContentView.swift
//  FirebaseChatApp
//
//  Created by 홍승표 on 5/21/24.
//

import SwiftUI

enum NavigationPath: String {
    case profile = "MyProfile"
    case chat = "Let's Chat"
    
    var symbolImage: String {
        switch self {
        case .chat:
            return "message"
        case .profile:
            return "person.crop.circle.fill"
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var fm: FirebaseManager
    @State private var navigationPath: NavigationPath = .chat
    
    var body: some View {
        if fm.isLoggedIn {
            TabView(selection: $navigationPath) {
                NavigationStack {
                    ChatView(navigationPath: $navigationPath)
                }
                .tag(NavigationPath.chat)
                .tabItem {
                    Label(NavigationPath.chat.rawValue, systemImage: NavigationPath.chat.symbolImage)
                }
                NavigationStack {
                    ProfileView(navigationPath: $navigationPath)
                }
                .tag(NavigationPath.profile)
                .tabItem {
                    Label(NavigationPath.profile.rawValue, systemImage: NavigationPath.profile.symbolImage)
                }
            }
        } else {
            SignInView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FirebaseManager.shared)
}
