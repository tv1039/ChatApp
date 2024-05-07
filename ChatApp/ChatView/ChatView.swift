//
//  ChatView.swift
//  ChatApp
//
//  Created by 홍승표 on 5/7/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject var chatViewModel = ChatViewModel()
    @State var text = ""
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(chatViewModel.messages) { message in
                        MessageView(message: message)
                    }
                }
            }
            HStack(spacing: 0) {
                TextField("메세지 보내기", text: $text, axis: .vertical)
                    .padding()
                    .background(Color(uiColor: .systemGray6))
                Button {
                    if text.count > 0 {
                        chatViewModel.sendMessage(text: text) { success in
                            if success {
                                
                            } else {
                                print("error sending message")
                            }
                        }
                    }
                    text = ""
                    
                } label: {
                    Text("Send")
                        .padding()
                }
            }
            .padding()
        }
    }
}

#Preview {
    ChatView()
}

