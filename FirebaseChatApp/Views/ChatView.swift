//
//  ChatView.swift
//  FirebaseChatApp
//
//  Created by 홍승표 on 5/22/24.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var fm: FirebaseManager
    @Binding var navigationPath: NavigationPath
    @State private var shouldShowLogOut: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                customNavBar
                messagesView
            }
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.fill")
                .font(.system(size: 24, weight: .heavy))
            VStack(alignment: .leading, spacing: 4) {
                Text("UserName")
                    .font(.system(size: 24, weight: .bold))
                HStack {
                    Circle()
                        .foregroundStyle(.green)
                        .frame(width: 12, height: 12)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(.lightGray))
                }
            }
            Spacer()
            Image(systemName: "plus.message")
                .font(.system(size: 22))
            
            Image(systemName: "gearshape")
                .font(.system(size: 22))
                .onTapGesture {
                    shouldShowLogOut.toggle()
                }
            
        }
        .padding()
    }
    
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color.primary, lineWidth: 1)
                            }
                        VStack(alignment: .leading) {
                            Text("UserName")
                                .font(.system(size: 14, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(.lightGray))
                        }
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    ChatView(navigationPath: .constant(.chat))
        .environmentObject(FirebaseManager())
}
