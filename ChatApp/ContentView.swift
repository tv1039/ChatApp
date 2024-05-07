//
//  ContentView.swift
//  ChatApp
//
//  Created by 홍승표 on 5/7/24.
//

import SwiftUI

struct ContentView: View {
    @State var showSignIn: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                ChatView()
            }
            .navigationTitle("Chatroom")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        do {
                            try AuthManager.shared.signOut()
                            showSignIn = true
                        } catch {
                            print("로그아웃 에러")
                        }
                        print("sign out")
                    } label: {
                        Text("Sign Out")
                            .foregroundStyle(.red)
                    }
                }
            }
            .fullScreenCover(isPresented: $showSignIn) {
                SignInView(showSignIn: $showSignIn)
            }
        }
        .onAppear {
            showSignIn = AuthManager.shared.getCurrentUser() == nil
        }
    }
}

#Preview {
    ContentView()
}
