//
//  CatDeleteView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/13.
//

import SwiftUI
import CoreData

struct CatDeleteView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        entity: CatEntity.entity(),
        sortDescriptors: []
    ) var allCats: FetchedResults<CatEntity>

    @StateObject private var viewModel = SettingViewModel()
    @EnvironmentObject var navigationModel: NavigationModel
    @Environment(\.dismiss) private var dismiss

    @State private var isReturnToTitleActive = false
    @State private var showingDeleteAlert = false
    @State private var selectedCatToDelete: CatEntity? = nil

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

                VStack(spacing: 20) {
                    Text("削除するペットを選んでください")
                        .font(.custom("Jiyucho", size: 24))
                        .padding()

                    if allCats.isEmpty {
                        Text("登録されたペットがいません")
                            .font(.custom("Jiyucho", size: 20))
                            .foregroundColor(.gray)
                            .padding(.top, 60)
                    } else {
                        List {
                            ForEach(allCats, id: \.self) { cat in
                                Button(role: .destructive) {
                                    selectedCatToDelete = cat
                                    showingDeleteAlert = true
                                } label: {
                                    HStack {
                                        if let imageData = cat.imageData,
                                           let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        }

                                        VStack(alignment: .leading) {
                                            Text(cat.name ?? "名前なし")
                                                .font(.custom("Jiyucho", size: 18))
                                            Text(cat.breed ?? "")
                                                .font(.custom("Jiyucho", size: 12))
                                        }
                                        Spacer()
                                        Text("削除")
                                            .foregroundColor(.red)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .frame(height: 400)
                        .scrollContentBackground(.hidden)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(12)
                        .padding()
                    }
                }
                .frame(width: 400)

                NavigationLink(destination: TitleView().environmentObject(navigationModel),
                               isActive: $isReturnToTitleActive) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationTitle("ペットを削除")
            .navigationBarTitleDisplayMode(.inline)

            .alert("このペットと記録を削除しますか？", isPresented: $showingDeleteAlert) {
                Button("削除", role: .destructive) {
                    if let id = selectedCatToDelete?.id {
                        viewModel.deleteCatAndRecords(catID: id)
                        isReturnToTitleActive = true
                    }
                }
                Button("キャンセル", role: .cancel) {
                    selectedCatToDelete = nil
                }
            }
        }
    }
}

