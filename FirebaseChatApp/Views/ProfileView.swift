//
//  ProfileView.swift
//  FirebaseChatApp
//
//  Created by 홍승표 on 5/22/24.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @EnvironmentObject var fm: FirebaseManager
    @Binding var navigationPath: NavigationPath
    @State private var shouldShowPhotoPicker: Bool = false
    
    var body: some View {
        VStack {
            if let user = fm.currentUser,
               let profileImage = user.profileImage,
               let url = URL(string: profileImage){
                WebImage(url: url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                
            }
            
            Text(fm.currentUser?.nickname ?? "정보없음")
                .font(.title)
                .fontWeight(.bold)
            
            Text(fm.currentUser?.email ?? "정보없음")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .onAppear {
            fm.fetchCurrentUser { success in
                if success {
                    print("사용자 정보를 성공적으로 가져왔습니다.")
                } else {
                    print("사용자 정보를 가져오는데 실패했습니다.")
                }
            }
        }
    }
}

#Preview {
    ProfileView(navigationPath: .constant(.profile))
        .environmentObject(FirebaseManager.shared)
}
