//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by 홍승표 on 5/7/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages = [Message]()
    
    @Published var mockData = [
        Message(userUid: "user1", text: "안녕 목데이터야", photoURL: "", createAt: Date()),
        Message(userUid: "user1", text: "안녕 목데이터야", photoURL: "", createAt: Date()),
        Message(userUid: "user1", text: "안녕 목데이터야", photoURL: "", createAt: Date()),
        Message(userUid: "user1", text: "안녕 목데이터야", photoURL: "", createAt: Date())
        
    ]
    
    init() {
        fetchMessage()
    }
    func fetchMessage() {
        DatabaseManager.shared.fetchMessages { [weak self] result in
            switch result {
            case .success(let msgs):
                self?.messages = msgs
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendMessage(text: String, completion: @escaping (Bool) -> Void) {
        guard let user = AuthManager.shared.getCurrentUser() else {
            return
        }
        
        let msg = Message(userUid: user.uid, text: text, photoURL: user.photoURL, createAt: Date())
        DatabaseManager.shared.sendMessageToDatebase(message: msg) { success in
            if success {
                self.messages.append(msg)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
