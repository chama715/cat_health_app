//
//  TimelineModalView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/13.
//

import SwiftUI

struct DiaryTextWrapper: Identifiable {
    let id = UUID()
    let text: String
}

struct TimelineModalView: View {
    let records: [RecordEntity]
    let selectedDate: Date

    @State private var selectedDiaryText: DiaryTextWrapper? = nil

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

                VStack(spacing: 12) {
                    // 日付の表示
                    Text(formattedDate(selectedDate))
                        .font(.custom("Jiyucho", size: 24))
                        .padding(.top)

                    if records.isEmpty {
                        Text("この日の記録はありません")
                            .font(.custom("Jiyucho", size: 18))
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            ForEach(records, id: \.objectID) { record in
                                HStack(spacing: 12) {
                                    Image(systemName: record.iconName ?? "questionmark")
                                        .foregroundColor(.softTiffany)
                                    Text(timeFormatter(date: record.time ?? Date()))
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .frame(width: 70, alignment: .leading)
                                    Text(formatContent(record))
                                        .font(.system(size: 16))
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.6))
                                .cornerRadius(10)
                                .padding(.horizontal, 8)
                                .onTapGesture {
                                    if record.categoryName == "日記",
                                       let detail = record.detail,
                                       !detail.isEmpty {
                                        selectedDiaryText = DiaryTextWrapper(text: detail)
                                    }
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .frame(width: 400)
                .padding()
            }
        }
        // 日記モーダルの表示
        .sheet(item: $selectedDiaryText) { wrapper in
            VStack(spacing: 20) {
                Text("日記の内容")
                    .font(.custom("Jiyucho", size: 24))
                ScrollView {
                    Text(wrapper.text)
                        .font(.system(size: 16))
                        .padding()
                }
                Button("閉じる") {
                    selectedDiaryText = nil
                }
                .padding()
            }
            .padding()
            .frame(width: 400)
            .background(Color.white.opacity(0.95))
            .cornerRadius(20)
            .presentationDetents([.medium])
        }
    }

    // 日付の整形
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    // 時間の整形
    private func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    // 記録内容の整形
    private func formatContent(_ record: RecordEntity) -> String {
        let name = record.categoryName ?? ""
        let detail = record.detail ?? ""
        if name == "日記" {
            return "日記"
        }
        return detail.isEmpty ? name : "\(name) \(detail)"
    }
}
