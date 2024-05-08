//
//  SignInView.swift
//  ChatApp
//
//  Created by 홍승표 on 5/7/24.
//

import SwiftUI

struct SignInView: View {
    @Binding var showSignIn: Bool
    var body: some View {
        VStack {
            Image("images")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 400, maxHeight: 450, alignment: .top)
            Spacer()
            VStack(spacing: 10) {
                Button {
                    print("apple")
                } label: {
                    Text("Sign in with Apple")
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
                    AuthManager.shared.signInWithGoogle { result in
                        switch result {
                        case .success(_):
                            showSignIn = false
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
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
            }
            Spacer()
        }
        .ignoresSafeArea(.all, edges: .top)
    }
    
}

#Preview {
    SignInView(showSignIn: .constant(true))
}
