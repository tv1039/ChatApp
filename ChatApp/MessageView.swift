//
//  MassageView.swift
//  ChatApp
//
//  Created by 홍승표 on 5/7/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        if message.isFromCurrentUser() {
            HStack {
                HStack {
                    Text(message.text)
                        .padding()
                        .background(Color(uiColor: .systemBlue))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .frame(maxWidth: 260, alignment: .trailing)
                
                // 이미지 캐싱
                if let photoURL = message.fetchPhotoURL() {
                    WebImage(url: photoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(maxWidth: 35, maxHeight: 35, alignment: .top)
                        .padding(.trailing, 4)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .foregroundStyle(.gray)
                        .frame(maxWidth: 35, maxHeight: 35, alignment: .top)
                        .padding(.trailing, 4)
                }
            }
            .frame(maxWidth: 360, alignment: .trailing)
        } else {
            HStack {
                // 이미지 캐싱
                if let photoURL = message.fetchPhotoURL() {
                    WebImage(url: photoURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(maxWidth: 35, maxHeight: 35, alignment: .top)
                        .padding(.trailing, 4)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .foregroundStyle(.gray)
                        .frame(maxWidth: 35, maxHeight: 35, alignment: .top)
                        .padding(.trailing, 4)
                }
                
                HStack {
                    Text(message.text)
                        .padding()
                        .background(Color(uiColor: .systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .frame(maxWidth: 260, alignment: .leading)
            }
            .frame(maxWidth: 360, alignment: .leading)
        }
    }
}

#Preview {
    MessageView(message: Message(userUid: "user", text: "안녕 난 채팅앱이야", photoURL: "", createAt: Date()))
}
