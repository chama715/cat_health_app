//
//  MainView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    @State private var showingDetailInput = false
    @State private var selectedCategoryForDetail: RecordCategory? = nil
    @State private var isCatSelectActive = false
    @State private var currentDate: Date = Date()

    @AppStorage("selectedCatID") private var selectedCatID: String = ""

    @FetchRequest(
        entity: CatEntity.entity(),
        sortDescriptors: []
    ) private var allCats: FetchedResults<CatEntity>

    private var selectedCat: CatEntity? {
        allCats.first(where: { $0.id?.uuidString == selectedCatID })
    }

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

            VStack(spacing: 8) {
                petHeaderView
                dateNavigationView
                timelineView
                categoryGridView
            }
            .frame(maxHeight: .infinity, alignment: .top)


            
            .onAppear {
                viewModel.fetchRecords(for: currentDate)
            }
            .onChange(of: currentDate) { newDate in
                viewModel.fetchRecords(for: newDate)
            }

            NavigationLink(destination: CatSelectView(), isActive: $isCatSelectActive) {
                EmptyView()
            }
            .hidden()
        }
        .sheet(item: $selectedCategoryForDetail) { (category: RecordCategory) in
            DetailInputView(RecordCategory: category) { detailText in
                viewModel.addRecord(category: category, detail: detailText)
            }
        }
    }



    // MARK: - ペット情報ヘッダー
    private var petHeaderView: some View {
        HStack {
            if let cat = selectedCat {
                if let imageData = cat.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 3)
                        
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 3)
                        
                }
                    

                VStack {
                    Text(cat.name ?? "名前なし")
                        .font(.custom("Jiyucho", size: 20))
                    if let birthDate = cat.birthDate {
                        Text(calculateAge(from: birthDate))
                            .font(.custom("Jiyucho", size: 12))
                           
                    }
                    Text(cat.breed ?? "猫種不明")
                        .font(.custom("Jiyucho", size: 12))
                        
                }
                
            } else {
                Text("猫が選択されていません")
                    .font(.custom("Jiyucho", size: 20))
            }

            Button(action: {
                isCatSelectActive = true
            }) {
                Image(systemName: "calendar")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    
            }
        }
    }
    
    // MARK: - 日付表示と切り替えボタン
    private var dateNavigationView: some View {
        HStack {
            Button(action: {
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            }) {
                Image(systemName: "chevron.left")
            }
            
            Text(formattedDate(currentDate))
                .font(.custom("Jiyucho", size: 20))
            
            Button(action: {
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            }) {
                Image(systemName: "chevron.right")
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
        let columns = Array(repeating: GridItem(.fixed(50)), count: 6)

        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(viewModel.categories) { category in
                Button(action: {
                    if category.name == "猫選択" {
                        isCatSelectActive = true
                    } else if category.requiresDetail {
                        selectedCategoryForDetail = category
                    } else {
                        viewModel.addRecord(category: category)
                    }
                }) {
                    VStack(spacing: 1) {
                        Image(systemName: category.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
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

    // MARK: - 年齢計算
    private func calculateAge(from birthDate: Date) -> String {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year, .month], from: birthDate, to: Date())
        let years = ageComponents.year ?? 0
        let months = ageComponents.month ?? 0
        return "\(years)歳 \(months)ヶ月"
    }
}

// MARK: - 日付変更のやつ
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.dateStyle = .long
    return formatter.string(from: date)
}

#Preview {
    MainView()
}
