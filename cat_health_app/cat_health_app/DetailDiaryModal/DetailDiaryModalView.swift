//
//  DetailDiaryModalView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/16.
//

import SwiftUI

struct DetailDiaryModalView: View {
    let diaryText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("日記の内容")
                .font(.custom("Jiyucho", size: 24))
                .padding(.top)

            ScrollView {
                Text(diaryText)
                    .font(.system(size: 20))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding()
        .background(
            ZStack {
                Image("paw_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.2),
                        Color.softTiffany.opacity(0.5),
                        Color.white.opacity(0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
        )
    }
}
