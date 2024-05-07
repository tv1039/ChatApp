//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by 홍승표 on 5/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// 에러 처리
enum FatchMessagesError: Error {
    case snapshotError
}

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let messageRef = Firestore.firestore().collection("messages")
    
    func fetchMessages(completion: @escaping (Result<[Message], FatchMessagesError>) -> Void) {
        messageRef.order(by: "createdAt", descending: true).limit(to: 25).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(.snapshotError))
                return
            }
            
            let docs = snapshot.documents
            
            var messages = [Message]()
            for doc in docs {
                let data = doc.data()
                let text = data["text"] as? String ?? "Error"
                let userUid = data["userUid"] as? String ?? "Error"
                let photoURL = data["photoURL"] as? String ?? "Error"
                let createAt = data["createAt"] as? Timestamp ?? Timestamp()
                
                let msg = Message(userUid: userUid, text: text, photoURL: photoURL, createAt: createAt.dateValue())
                messages.append(msg)
            }
            completion(.success(messages))
        }
    }
    
    func sendMessageToDatebase(message: Message, completion: @escaping (Bool) -> Void) {
        let data = [
            "text": message.text,
            "userUid": message.userUid,
            "photoURL": message.photoURL ?? "",
            "createdAt": Timestamp(date: message.createAt)
        ] as [String : Any]
        
        messageRef.addDocument(data: data) { error in
            guard error == nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
