//
//  FirebaseManager.swift
//  FirebaseChatApp
//
//  Created by 홍승표 on 5/21/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    @Published var currentUser: User?
    @Published var isPasswordVisible: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var isNicknameDuplicate: Bool = false
    @Published var isEmailDuplicate: Bool = false
    
    
    // 로그인 함수
    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("로그인 실패!", error)
                completion(false)
                return
            }
            print("로그인 성공!\(result?.user.uid ?? "")")
            self.isLoggedIn = true
            completion(true)
        }
    }
    
    // 사용자 정보 저장 함수
    private func saveUser(user: User, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("users").document(user.userId).setData(from: user) { error in
                if let error = error {
                    print("사용자 정보 저장 오류: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            print("사용자 정보 인코딩 오류: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // 닉네임 중복 검사 함수
    func checkNicknameDuplicate(nickname: String, completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .whereField("nickname", isEqualTo: nickname)
            .getDocuments { querySnapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("닉네임 중복 확인 오류: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    // 중복된 닉네임이 있는지 여부를 완료 클로저를 통해 반환
                    if let querySnapshot = querySnapshot {
                        completion(!querySnapshot.isEmpty)
                    } else {
                        completion(false)
                    }
                }
            }
    }
    
    // 이메일 중복 검사 함수
    func checkEmailDuplicate(email: String, completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments { querySnapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("이메일 중복 확인 오류: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    // 중복된 이메일이 있는지 여부를 완료 클로저를 통해 반환
                    if let querySnapshot = querySnapshot {
                        completion(!querySnapshot.isEmpty)
                    } else {
                        completion(false)
                    }
                }
            }
    }
    
    // 프로필 사진 업로드
    func uploadProfileImage(userId: String, image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("이미지를 Data로 변환하는데 실패했습니다.")
            completion(nil)
            return
        }
        
        let storageRef = storage.reference().child("profile_images/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("이미지 업로드 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("이미지 URL 가져오기 실패: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(url)
                }
            }
        }
    }
    
    // 사용자 정보에 프로필 이미지 URL 저장 함수
    func saveProfileImageUrl(userId: String, url: URL, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).updateData(["profileImageUrl": url.absoluteString]) { error in
            if let error = error {
                print("프로필 이미지 URL 저장 실패: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // 계정 생성 함수
    func createNewAccount(email: String, password: String, confirmPassword: String, nickname: String, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        if password == confirmPassword {
            auth.createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("계정 생성 실패: ", error)
                    completion(false)
                    return
                }
                // 프로필 이미지 업로드 및 사용자 정보 저장
                if let profileImage = profileImage {
                    self.uploadAndSaveProfileImage(userId: result!.user.uid, image: profileImage, nickname: nickname, email: email, completion: completion)
                } else {
                    // 이미지가 없을때
                    // 사용자 정보 저장
                    let user = User(userId: result!.user.uid, nickname: nickname, email: email)
                    self.saveUser(user: user, completion: completion)
                }
            }
        } else {
            print("비밀번호가 일치하지 않습니다.")
            completion(false)
        }
    }
    // 프로필 이미지 업로드 및 사용자 정보 저장 함수
    private func uploadAndSaveProfileImage(userId: String, image: UIImage, nickname: String, email: String, completion: @escaping (Bool) -> Void) {
        self.uploadProfileImage(userId: userId, image: image) { url in
            // 사용자 정보 저장
            var user = User(userId: userId, nickname: nickname, email: email)
            user.profileImage = url?.absoluteString
            self.saveUser(user: user, completion: completion)
        }
    }
    
    // 로그인한 사용자 정보 가져오기
    func fetchCurrentUser(completion: @escaping (Bool) -> Void) {
        guard let userId = auth.currentUser?.uid else {
            print("현재 사용자 ID를 가져오는데 실패했습니다.")
            completion(false)
            return
        }
        
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("사용자 정보 가져오기 실패: \(error.localizedDescription)")
                completion(false)
            } else if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    self.currentUser = user
                    completion(true)
                } catch {
                    print("사용자 정보 디코딩 실패: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                print("사용자 정보가 존재하지 않습니다.")
                completion(false)
            }
        }
    }


}
