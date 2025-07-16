//
//  HelpPageView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/14.
//

import SwiftUI

struct HelpPageView: View {
    
    @Environment(\.dismiss) var dismiss
    
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
                Text("使い方ガイド")
                    .font(.custom("Jiyucho", size: 40))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("メイン画面")
                            .font(.custom("Jiyucho", size: 32))
                        Text("上部には選択中の猫ちゃんの情報が表示されます。\n中央にはタイムラインが表示され、下部のボタンをタップすることで、タイムラインにお世話や様子を記録できます。")
                            .font(.custom("Jiyucho", size: 20))
                        Text("ペット登録画面")
                            .font(.custom("Jiyucho", size: 32))
                        Text("飼っている猫ちゃんを複数登録することができます。\n登録したペットごとにタイムラインを表示させることが可能です。")
                            .font(.custom("Jiyucho", size: 20))
                        Text("カレンダー画面")
                            .font(.custom("Jiyucho", size: 32))
                        Text("確認したい日にちをタップすれば、その日のタイムラインを確認することができます。")
                            .font(.custom("Jiyucho", size: 20))
                        Text("設定画面")
                            .font(.custom("Jiyucho", size: 32))
                        Text("設定画面では、ペットの情報を削除したり、全ての情報をリセットすることが可能です。")
                            .font(.custom("Jiyucho", size: 20))
                    }
                    .padding()
                }
                
                // 設定画面に遷移
                Button(action: {
                    dismiss()
                }) {
                    Text("← 設定画面に戻る")
                        .font(.custom("Jiyucho", size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(10)
                }
                
                
            }
            .frame(width: 400)
            .padding()
            
        }
    }
}
