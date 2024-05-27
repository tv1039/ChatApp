//
//  SignUpView.swift
//  FirebaseChatApp
//  Created by 홍승표 on 5/21/24.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct SignUpView: View {
    @EnvironmentObject var fm: FirebaseManager
    @State private var userNickname = ""
    @State private var userEmail = ""
    @State private var userPassword = ""
    @State private var confirmPassword = ""
    @State private var shouldShowPhotoPicker = false
    @State private var profileImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @Binding var showingCreateAccountSheet: Bool
    @Environment(\.dismiss) var dismiss
    
    var isValidEmail: Bool {
        // 이메일 형식 검증 로직
        return userEmail.contains("@") && userEmail.contains(".")
    }
    
    var isValidPassword: Bool {
        // 비밀번호 길이 검증 로직
        return userPassword.count >= 6
    }
    
    var isPasswordConfirmed: Bool {
        // 비밀번호 확인 검증 로직
        return userPassword == confirmPassword
    }
    
    var isFormValid: Bool {
        // 전체 폼 유효성 검증 로직
        return !userNickname.isEmpty && isValidEmail && isValidPassword && isPasswordConfirmed && !fm.isEmailDuplicate && !fm.isNicknameDuplicate
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            }
            
            VStack(alignment: .center) {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .onTapGesture {
                            shouldShowPhotoPicker.toggle()
                        }
                    
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .onTapGesture {
                            shouldShowPhotoPicker.toggle()
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30)
            .photosPicker(isPresented: $shouldShowPhotoPicker, selection: $selectedItem, matching: .images)
            .onChange(of: selectedItem) {_, _ in
                Task {
                    if let selectedItem,
                       let data = try? await selectedItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            profileImage = image
                        }
                    }
                    selectedItem = nil
                }
            }
            
            TextField("닉네임을 입력해주세요.", text: $userNickname)
                .frame(height: 25)
                .padding()
                .border(Color.gray, width: 0.5)
                .onChange(of: userNickname) {
                    fm.checkNicknameDuplicate(nickname: userNickname) { isDuplicate in
                        fm.isNicknameDuplicate = isDuplicate
                    }
                }
            if fm.isNicknameDuplicate {
                Text("중복된 닉네임 입니다.")
                    .foregroundStyle(.red)
            }
            
            TextField("이메일을 입력해주세요", text: $userEmail)
                .frame(height: 25)
                .padding()
                .border(Color.gray, width: 0.5)
                .onChange(of: userEmail) {
                    fm.checkEmailDuplicate(email: userEmail) { isDuplicate in
                        fm.isEmailDuplicate = isDuplicate
                    }
                }
            if !isValidEmail && !userEmail.isEmpty {
                Text("올바른 이메일 형식이 아닙니다.")
                    .foregroundStyle(.red)
            } else if fm.isEmailDuplicate {
                Text("이미 가입한 메일이 있습니다.")
                    .foregroundStyle(.red)
            }
        
            HStack {
                if fm.isPasswordVisible {
                    TextField("비밀번호", text: $userPassword)
                } else {
                    SecureField("비밀번호", text: $userPassword)
                }
                Image(systemName: fm.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    .onTapGesture {
                        fm.isPasswordVisible.toggle()
                    }
            }
            .frame(height: 25)
            .padding()
            .border(Color.gray, width: 0.5)
            if !isValidPassword && !userPassword.isEmpty {
                Text("비밀번호는 6글자 이상이어야 합니다.")
                    .foregroundStyle(.red)
            }
            
            HStack {
                if fm.isPasswordVisible {
                    TextField("비밀번호 재확인", text: $confirmPassword)
                } else {
                    SecureField("비밀번호 재확인", text: $confirmPassword)
                }
                Image(systemName: fm.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    .onTapGesture {
                        fm.isPasswordVisible.toggle()
                    }
            }
            .frame(height: 25)
            .padding()
            .border(Color.gray, width: 0.5)
            if !isPasswordConfirmed && !confirmPassword.isEmpty {
                Text("비밀번호가 불일치합니다.")
                    .foregroundStyle(.red)
            }
            Spacer()
            Button{
                if isFormValid {
                    fm.createNewAccount(email: userEmail, password: userPassword, confirmPassword: confirmPassword, nickname: userNickname, profileImage: profileImage) { success in
                        if success {
                            print("회원가입 성공")
                            dismiss()
                        } else {
                            print("회원가입 실패")
                            
                        }
                    }
                }
                
            } label: {
                Text("회원가입")
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.white)
            .background(isFormValid ? Color.blue : Color.gray)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(userNickname.isEmpty || userEmail.isEmpty || userPassword.isEmpty || confirmPassword.isEmpty)
        }
        
        .padding()
        Spacer()
    }
}


#Preview {
    SignUpView(showingCreateAccountSheet: .constant(false))
        .environmentObject(FirebaseManager.shared)
}
