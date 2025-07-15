//
//  MainView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @StateObject private var viewModel = MainViewModel()

    @State private var selectedCategoryForDetail: RecordCategory? = nil
    @State private var currentDate: Date = Date()
    @State private var isCatSelectActive = false
    @State private var isSettingActive = false
    @State private var isTitleReturnActive = false
    @State private var isCalendarActive = false

    @AppStorage("selectedCatID") private var selectedCatID: String = ""

    @FetchRequest(entity: CatEntity.entity(), sortDescriptors: [])
    private var allCats: FetchedResults<CatEntity>

    private var selectedCat: CatEntity? {
        allCats.first(where: { $0.id?.uuidString == selectedCatID })
    }

    var body: some View {
        ZStack {
            backgroundView

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

            navigationLinks
        }
        .sheet(item: $selectedCategoryForDetail) { category in
            let dateForSave = currentDate

            DetailInputView(
                RecordCategory: category,
                recordDate: dateForSave
            ) { detailText, selectedDate in
                print("🐾 保存される selectedDate: \(selectedDate)")
                viewModel.addRecord(category: category, detail: detailText, for: selectedDate)
                viewModel.fetchRecords(for: selectedDate)
                currentDate = selectedDate
            }
        }
    }

    private var backgroundView: some View {
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
        }
    }

    private var navigationLinks: some View {
        Group {
            NavigationLink(destination: CatSelectView(), isActive: $isCatSelectActive) { EmptyView() }
            NavigationLink(destination: SettingView().environmentObject(navigationModel), isActive: $isSettingActive) { EmptyView() }
            NavigationLink(destination: TitleView(), isActive: $isTitleReturnActive) { EmptyView() }
            NavigationLink(destination: CalendarView(), isActive: $isCalendarActive) { EmptyView() }
        }
        .hidden()
    }

    private var petHeaderView: some View {
        HStack {
            if let cat = selectedCat {
                catImageView(cat: cat)
                catInfoView(cat: cat)
            } else {
                Text("猫が選択されていません")
                    .font(.custom("Jiyucho", size: 20))
            }

            Button(action: { isCalendarActive = true }) {
                Image(systemName: "calendar")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
            }
        }
    }

    private func catImageView(cat: CatEntity) -> some View {
        Group {
            if let imageData = cat.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 3)
            } else {
                Image(systemName: "photo")
            }
        }
        .frame(width: 60, height: 60)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 2))
        .shadow(radius: 3)
    }

    private func catInfoView(cat: CatEntity) -> some View {
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
    }

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

    private var timelineView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(radius: 5)
                .padding(.horizontal)
                .frame(width: 400, height: 500)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.records) { record in
                        timelineRecordView(record)
                    }
                }
                .padding(.vertical)
            }
            .frame(width: 370, height: 500)
        }
    }

    private func timelineRecordView(_ record: CatRecord) -> some View {
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

    private var categoryGridView: some View {
        let columns = Array(repeating: GridItem(.fixed(50)), count: 6)

        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(viewModel.categories) { category in
                Button(action: {
                    handleCategoryTap(category)
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

    private func handleCategoryTap(_ category: RecordCategory) {
        switch category.name {
        case "猫選択":
            isCatSelectActive = true
        case "設定":
            isSettingActive = true
        default:
            if category.requiresDetail {
                selectedCategoryForDetail = category  // ← ここが修正ポイント！
            } else {
                viewModel.addRecord(category: category, for: currentDate)
                viewModel.fetchRecords(for: currentDate)
            }
        }
    }

    private func calculateAge(from birthDate: Date) -> String {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year, .month], from: birthDate, to: Date())
        let years = ageComponents.year ?? 0
        let months = ageComponents.month ?? 0
        return "\(years)歳 \(months)ヶ月"
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
