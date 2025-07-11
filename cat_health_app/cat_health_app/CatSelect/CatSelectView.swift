//
//  CatSelectView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

import SwiftUI

struct CatSelectView: View {
    @State private var isMainViewActive = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("猫選択画面")
                    .font(.largeTitle)
                    .bold()
                
                // 今後猫の一覧表示や選択処理をここで行う
                
                Button("この猫で進む") {
                    isMainViewActive = true
                }
                .padding()
                .frame(width: 200)
                .background(Color.softTiffany)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                // ✅ MainViewへのNavigationLink
                NavigationLink(destination: MainView(), isActive: $isMainViewActive) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationTitle("猫選択")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CatSelectView()
}
