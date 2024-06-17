//
//  KakaoManager.swift
//  FirebaseChatApp
//
//  Created by 홍승표 on 6/17/24.
//

import Foundation
import KakaoSDKUser

class KakaoManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    
    func handleLoginWithKakaoTalkApp() async -> Bool {
        await withCheckedContinuation { continuation in
            // 카카오 웹뷰로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func handleLoginWithKakaoAccount() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor
    func handleKakoLogin() {
        Task {
            // 카카오가 사용자의 앱 설치가 되어있는지 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오 앱을 통해 로그인
                isLoggedIn = await handleLoginWithKakaoTalkApp()
            } else {
                // 카카오 웹뷰로 로그인
                isLoggedIn = await handleLoginWithKakaoAccount()
            }
        }
    }
    
    func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
            }
        }
    }
    
}
