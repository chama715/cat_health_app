//
//  CatRegisterView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

/*
 ペット登録画面。
 背景や色はタイトル画面と同じで、フォントもじゆうちょうフォントを採用。
 スクロールビューで入力欄を。
 名前は自由に入力できる。
 性別はオスかメスかをピッカーで選択。
 猫種は名前と同様、入力できるように。
 生年月日を入力すれば年齢が出る仕様に。
 写真はカメラロールから保存できるように。
 ボタンを押すと情報が保存されるように。
 */

import SwiftUI
import PhotosUI

struct CatRegisterView: View {
    @StateObject private var viewModel = CatRegisterViewModel()
    @Environment(\.managedObjectContext) private var context
    @State private var isCatSelectActive = false

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

                ScrollView {
                    VStack(spacing: 20) {
                        Text("新しいペットを登録する")
                            .font(.custom("Jiyucho", size: 24))
                            .padding(.bottom)

                        Group {
                            Text("名前")
                                .font(.custom("Jiyucho", size: 20))
                            TextField("例: たま", text: $viewModel.catName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 400)

                            Text("性別")
                                .font(.custom("Jiyucho", size: 20))
                            Picker("性別", selection: $viewModel.gender) {
                                ForEach(viewModel.genders, id: \.self) { gender in
                                    Text(gender)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 400)

                            Text("猫種")
                                .font(.custom("Jiyucho", size: 20))
                            TextField("例: スコティッシュフォールド", text: $viewModel.breed)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 400)

                            Text("生年月日")
                                .font(.custom("Jiyucho", size: 20))
                            DatePicker("", selection: $viewModel.birthDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .frame(width: 100)

                            Text("生年月日: \(viewModel.birthDateFormatted)")
                                .font(.custom("Jiyucho", size: 20))

                            Text("年齢: \(viewModel.ageYearsText) 歳 \(viewModel.ageMonthsText) ヶ月")
                                .font(.custom("Jiyucho", size: 20))
                                .padding(.top)
                        }

                        Text("写真")
                            .font(.custom("Jiyucho", size: 20))

                        PhotosPicker(selection: $viewModel.selectedPhoto, matching: .images) {
                            if let selectedImage = viewModel.selectedImage {
                                selectedImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(12)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 200)
                                    .overlay(Text("写真を選択").foregroundColor(.gray))
                            }
                        }
                        .onChange(of: viewModel.selectedPhoto) { newItem in
                            if newItem != nil {
                                Task {
                                    await viewModel.loadImageFromPicker()
                                }
                            }
                        }
                        .frame(width: 400)

                        Button(action: {
                            viewModel.saveCat(context: context)
                            isCatSelectActive = true
                        }) {
                            Text("登録する")
                                .font(.custom("Jiyucho", size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.top)

                        NavigationLink(destination: CatSelectView(), isActive: $isCatSelectActive) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    CatRegisterView()
}
