//
//  CatRegisterView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

import SwiftUI
import PhotosUI

struct CatRegisterView: View {
    @StateObject private var viewModel = CatRegisterViewModel()

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
                        viewModel.registerCat()
                        // 登録後の遷移処理を追加可能
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
                }
                .padding()
            }
        }
    }
}

#Preview {
    CatRegisterView()
}
