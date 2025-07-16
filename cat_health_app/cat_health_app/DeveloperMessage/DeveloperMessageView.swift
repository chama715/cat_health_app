//
//  DeveloperMessageView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/14.
//

import SwiftUI

struct DeveloperMessageView: View {
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
                Text("開発者からのメッセージ")
                    .font(.custom("Jiyucho", size: 28))

                ScrollView {
                    Text("""
                    『ねこ手帳』をダウンロードしていただき、誠にありがとうございます。
                    
                    このアプリは、みなさまの飼っている猫ちゃんがより幸せになるようにという思いをこめて開発しました🐱
                    
                    猫ちゃんのおしっこやうんちの回数を記録し日々の健康管理をするのもよし、動物病院の獣医さんに症状を伝えるためにお薬の回数や与えた時間をチェックするために使うのもよし、地域の野良猫ちゃんを登録しておき、ごはんやおやつ、水を与えた記録を残しておくことにもお使いいただけます。
                    
                    複数の猫ちゃんを登録しておけるので、多頭飼いのご家庭の方にも使っていただけるのではないでしょうか🐾
                    
                    このアプリを通じて、1匹でも多くの猫ちゃんが幸せになり、飼い主様のお役に立てれば幸いです☺️
                    
                    私自身も猫を飼っており、日々生活している中で感じていた「こんなのあったらいいな！」を作った次第です。
                    
                    今後も、みなさまが気持ちよくアプリを利用していただけるため、さまざまな機能や改善をしていく予定です。
                    
                    「こういう機能があったら嬉しい！」「この部分をもう少しこうしてくれない？」などご意見がありましたら、お気軽におっしゃってください。
                    
                    猫好きのみなさまと一緒に、この『ねこ手帳』をよりよいアプリに仕上げていきたいと考えております🐈
                    """)
                    .font(.custom("Jiyucho", size: 20))
                    .padding()
                }
                .frame(width: 400)

                // 設定画面に遷移
                Button(action: {
                    dismiss()
                }) {
                    Text("← 設定に戻る")
                        .font(.custom("Jiyucho", size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
