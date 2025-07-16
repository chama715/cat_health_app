//
//  CatSelectView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

import SwiftUI

struct CatSelectView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: CatSelectViewModel
    @AppStorage("selectedCatID") private var selectedCatID: String = ""
    @State private var isMainViewActive = false
    @State private var isCatRegisterActive = false
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: CatSelectViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
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
                
                VStack {
                    // 猫が登録されていなければ...されていれば...表示
                    if viewModel.cats.isEmpty {
                        Text("登録された猫がいません")
                            .font(.custom("Jiyucho", size: 24))
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(viewModel.cats, id: \.id) { cat in
                                    // 写真が登録されていればそれを表示。されていなければ、デフォの画像なしを表示。
                                    HStack {
                                        if let imageData = cat.imageData,
                                           let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                        }
                                        
                                        // 名前や猫種、年齢を登録されていれば表示。
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(cat.name ?? "名前なし")
                                                .font(.custom("Jiyucho", size: 20))
                                                .foregroundColor(.black)
                                            Text(cat.breed ?? "猫種不明")
                                                .font(.custom("Jiyucho", size: 12))
                                                .foregroundColor(.black)
                                            if let birthDate = cat.birthDate {
                                                Text("年齢: \(viewModel.calculateAgeText(from: birthDate))")
                                                    .font(.custom("Jiyucho", size: 12))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .frame(width: 300)
                                    .padding()
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                                    
                                    // 猫の欄をタップすると実行
                                    .onTapGesture {
                                        viewModel.selectCat(cat)
                                        if let id = cat.id?.uuidString {
                                            selectedCatID = id
                                            isMainViewActive = true
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // ペット登録のボタン
                    NavigationLink(destination: CatRegisterView(), isActive: $isCatRegisterActive) {
                        Button(action: {
                            isCatRegisterActive = true
                        }) {
                            Text("＋ ペットを登録する")
                                .font(.custom("Jiyucho", size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 240)
                                .background(Color.blue)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                // 猫をタップした時の画面遷移のリンク。メイン画面へ。
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
