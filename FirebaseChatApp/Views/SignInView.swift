//  ContentView.swift
//  FirebaseChatApp
//  Created by 홍승표 on 5/21/24.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @EnvironmentObject var fm: FirebaseManager
    @EnvironmentObject var km: KakaoManager
    @State private var userEmail = ""
    @State private var userPassword = ""
    @State private var showingCreateAccountSheet = false
    
    let loginStatusInfo: (Bool) -> String = { isLoggedIn in
        return isLoggedIn ? "로그인 상태" : "로그아웃 상태"
    }
    
    var body: some View {
        VStack {
            TextField("이메일을 입력해주세요.", text: $userEmail)
                .padding()
                .border(Color.gray, width: 0.5)
                .frame(height: 20)
                .padding(.bottom, 20)
            HStack {
                if fm.isPasswordVisible {
                    TextField("비밀번호를 입력해주세요.", text: $userPassword)
                } else {
                    SecureField("비밀번호를 입력해주세요", text: $userPassword)
                }
                Image(systemName: fm.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    .onTapGesture {
                        fm.isPasswordVisible.toggle()
                    }
            }
            .frame(height: 20)
            .padding()
            .border(Color.gray, width: 0.5)
            .padding(.bottom, 20)
            
            VStack(spacing: 10) {
                Button {
                    fm.loginUser(email: userEmail, password: userPassword) { success in
                        if success {
                            print("로그인 성공")
                        } else {
                            print("로그인 실패")
                        }
                    }
                } label: {
                    Text("Log In")
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .frame(width: 300)
                        }
                }
                .frame(width: 300)
                .foregroundStyle(.primary)
                
                Button {
                    
                } label: {
                    Text("Sign in with Google")
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .frame(width: 300)
                        }
                }
                .frame(width: 300)
                .foregroundStyle(.primary)
                
                Button {
                    km.handleKakoLogin()
                    print("Success: load to kakao SignView")
                } label: {
                    Image("kakao_login_large_wide")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: 300)
                .foregroundStyle(.primary)
                
                Button {
                    km.kakaoLogout()
                    print("Success: load to kakao SignView")
                } label: {
                    Text("카카오톡 로그아웃")
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .frame(width: 300)
                        }
                }
                .frame(width: 300)
                .foregroundStyle(.primary)
                .padding(.bottom, 30)
                
                Text("Sign Up")
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke()
                            .frame(width: 300)
                    }
                    .onTapGesture {
                        showingCreateAccountSheet = true
                    }
                    .fullScreenCover(isPresented: $showingCreateAccountSheet) {
                        SignUpView(showingCreateAccountSheet: $showingCreateAccountSheet)
                    }
                    .frame(width: 300)
                    .foregroundStyle(.primary)
                
                Text("카카오 \(loginStatusInfo(km.isLoggedIn))")
            }
        }
        .padding()
    }
}

#Preview {
    SignInView()
        .environmentObject(FirebaseManager.shared)
        .environmentObject(KakaoManager())
}
