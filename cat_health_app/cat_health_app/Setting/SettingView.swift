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
    @State private var isReturnToTitleActive = false
    @State private var isCatDeleteActive = false
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
                
                // リスト表示
                List {
                    // アプリ情報として開発者メッセージ、使い方ガイド、アプリのバージョン
                    Section(header: Text("アプリ情報")) {
                        NavigationLink(destination: DeveloperMessageView()) {
                            Text("開発者からのメッセージ")
                                .font(.custom("Jiyucho", size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300)
                                .background(Color.blue.opacity(0.6))
                                .cornerRadius(8)
                        }
                        
                        NavigationLink(destination: HelpPageView()) {
                            Text("使い方ガイド")
                                .font(.custom("Jiyucho", size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300)
                                .background(Color.blue.opacity(0.6))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("バージョン")
                            Spacer()
                            Text("1.0.0")
                        }
                        
                    }
                    
                    // データ管理として、全削除と個別削除
                    Section(header: Text("データ管理")) {
                        Button("全てのデータを削除") {
                            showingDeleteAlert = true
                        }
                        .alert("本当にすべてのデータを削除しますか？", isPresented: $showingDeleteAlert) {
                            Button("削除", role: .destructive) {
                                viewModel.deleteAllData()
                                isReturnToTitleActive = true
                            }
                            Button("キャンセル", role: .cancel) {}
                        }
                        
                        Button("ペットを選んで削除") {
                            isCatDeleteActive = true
                            
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.7))
                .cornerRadius(12)
                .padding()
            }
            .frame(width: 400)
            
            // 削除→タイトルに戻るためのリンク
            NavigationLink(destination: TitleView().environmentObject(navigationModel),
                           isActive: $isReturnToTitleActive) {
                EmptyView()
            }
                           .hidden()
            
            // 個別削除へのリンク
            NavigationLink(destination: CatDeleteView(), isActive: $isCatDeleteActive) {
                EmptyView()
            }
            .hidden()
            
            
        }
    }
}
