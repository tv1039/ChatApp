//
//  AuthManager.swift
//  ChatApp
//
//  Created by 홍승표 on 5/7/24.
//

import Foundation
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

// 사용자 정보를 담는 구조체
struct ChatRoomUser {
    let uid: String
    let name: String
    let email: String?
    let photoURL: String?
}

// 에러 처리를 위한 열거형
enum GoogleSignInError: Error {
    case unableToGrabTopVC
    case signInPresentationError
    case authSignInError
}

class AuthManager {
    static let shared = AuthManager()
    let auth = Auth.auth()
    
    // 유저 정보
    func getCurrentUser() -> ChatRoomUser? {
        guard let authUser = auth.currentUser else {
            return nil
        }
        
        return ChatRoomUser(uid: authUser.uid, name: authUser.displayName ?? "Unknown", email: authUser.email, photoURL: authUser.photoURL?.absoluteString)
    }

    // Google Sign-In 설정을 초기화하는 메서드
    func signInWithGoogle(completion: @escaping (Result<ChatRoomUser, GoogleSignInError>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Google Sign-In 설정 생성
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // 뷰 컨트롤러를 가져오는 함수를 호출하여 topVC를 얻자
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(.unableToGrabTopVC))
            return
        }

        // Google Sign-In 플로우 시작!
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [unowned self] result, error in
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  error == nil
            else {
                completion(.failure(.signInPresentationError))
                return
            }

            // Google ID 토큰과 액세스 토큰을 사용하여 Firebase 인증 자격 증명 생성
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            // Firebase에 로그인
            auth.signIn(with: credential) { result, error in
                guard let result = result, error == nil else {
                    completion(.failure(.authSignInError))
                    return
                }

                // ChatRoomUser 인스턴스 생성
                let chatRoomUser = ChatRoomUser(uid: result.user.uid,
                                                name: result.user.displayName ?? "",
                                                email: result.user.email,
                                                photoURL: result.user.photoURL?.absoluteString)
                completion(.success(chatRoomUser))
            }
        }
    }
    // 로그아웃
    func signOut() throws{
        try auth.signOut()
    }
}



// 뷰 컨트롤러를 가져오는 확장
extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.compactMap { $0.windowScene?.windows }.flatMap { $0 }.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
