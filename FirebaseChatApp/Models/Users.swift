//
//  UserModel.swift
//  FirebaseChatApp
//
//  Created by 홍승표 on 5/23/24.
//

import Foundation

struct User: Codable {
    var userId: String
    var nickname: String
    var email: String
    var profileImage: String?
}
