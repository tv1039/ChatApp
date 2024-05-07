//
//  Message.swift
//  ChatApp
//
//  Created by 홍승표 on 5/7/24.
//

import Foundation
// 에러처리
enum MessageError {
    case noPhotoURL
}

struct Message: Decodable, Identifiable {
    var id: UUID = UUID()
    let userUid: String
    let text: String
    let photoURL: String?
    let createAt: Date
    
    // 유저 확인
    func isFromCurrentUser() -> Bool {
        guard let currentUser = AuthManager.shared.getCurrentUser() else {
            return false
        }
        
        if currentUser.uid == userUid {
            return true
        } else {
            return false
        }
    }
    
    // 사진 불러오기
    func fetchPhotoURL() -> URL? {
        guard let photoURLString = photoURL, 
                let url = URL(string: photoURLString) else {
            return nil
        }
        
        return url
    }
}
