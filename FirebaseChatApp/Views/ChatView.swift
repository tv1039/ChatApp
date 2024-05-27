//
//  ChatView.swift
//  FirebaseChatApp
//
//  Created by 홍승표 on 5/22/24.
//

import SwiftUI

struct ChatView: View {
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        Text("ChatView")
    }
}

#Preview {
    ChatView(navigationPath: .constant(.chat))
}
