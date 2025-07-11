//
//  MainView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
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
                petHeaderView
                timelineView
                Spacer()
                categoryGridView
            }
        }
    }
    
    // MARK: - ペット情報ヘッダー
    private var petHeaderView: some View {
        HStack(alignment: .center, spacing: 16) {
            Image("sample_cat")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 3)
            
            VStack {
                Text("たま")
                    .font(.title)
                    .bold()
                Text("3歳2ヶ月")
                    .font(.subheadline)
                Text("スコティッシュフォールド")
                    .font(.subheadline)
            }
            .padding()
            
            Button(action: {
                // カレンダー遷移処理予定
            }) {
                Image(systemName: "calendar")
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - 中央部タイムライン（白背景固定内でスクロール）
    private var timelineView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(radius: 5)
                .padding(.horizontal)
                .frame(height: 500)
                .frame(width: 400)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.records) { record in
                        HStack(spacing: 12) {
                            Image(systemName: record.iconName)
                                .foregroundColor(.softTiffany)
                            Text(record.time)
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .frame(width: 70, alignment: .leading)
                            Text(record.content)
                                .font(.system(size: 18))
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(10)
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.vertical)
            }
            .frame(height: 500)
            .frame(width: 370)
        }
    }
    
    // MARK: - 下部タイル
    private var categoryGridView: some View {
        let columns = Array(repeating: GridItem(.fixed(70)), count: 5)

        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(viewModel.categories) { category in
                Button(action: {
                    if category.requiresDetail {
                        print("\(category.name) の詳細入力モーダルを表示予定")
                    } else {
                        viewModel.addRecord(category: category)
                    }
                }) {
                    VStack(spacing: 1) {
                        Image(systemName: category.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .padding(3)
                            .background(Color.softTiffany.opacity(0.25))
                            .clipShape(Circle())

                        Text(category.name)
                            .font(.caption2)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                    }
                    .padding(4)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(6)
                }
            }
        }
    }




    
    
}

#Preview {
    MainView()
}
