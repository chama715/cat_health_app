//
//  SettingView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/13.
//

import SwiftUI

struct SettingView: View {

    @StateObject var viewModel = SettingViewModel()
    @State private var showingDeleteAlert = false
    @EnvironmentObject var navigationModel: NavigationModel


    var body: some View {
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

            VStack(spacing: 20) {
                Text("設定")
                    .font(.custom("Jiyucho", size: 28))
                    .padding(.top, 40)

                List {
                    Section(header: Text("データ管理")) {
                        Button("全てのデータを削除") {
                            showingDeleteAlert = true
                        }
                        .alert("本当にすべてのデータを削除しますか？", isPresented: $showingDeleteAlert) {
                            Button("削除", role: .destructive) {
                                viewModel.deleteAllData()
                                navigationModel.path = NavigationPath()
                            }
                            Button("キャンセル", role: .cancel) {}
                        }

                        Button("ペットを選んで削除") {
                            // 未実装
                        }
                    }

                    Section(header: Text("アプリ情報")) {
                        HStack {
                            Text("バージョン")
                            Spacer()
                            Text("1.0.0")
                        }

                        Button("開発者からのメッセージ") {
                            // 未実装
                        }

                        Button("アプリの使い方") {
                            // 未実装
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.7))
                .cornerRadius(12)
                .padding()
            }
            .frame(width: 400)
        }
    }
}
