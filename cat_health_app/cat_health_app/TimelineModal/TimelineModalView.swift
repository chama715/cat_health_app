//
//  TimelineModalView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/13.
//

import SwiftUI

struct TimelineModalView: View {
    let records: [RecordEntity]
    let selectedDate: Date

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
                            }
                        }
                    }

                    Spacer()
                }
                .frame(width: 400)
                .padding()
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    private func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private func formatContent(_ record: RecordEntity) -> String {
        let name = record.categoryName ?? ""
        let detail = record.detail ?? ""
        if name == "日記" {
            return "日記"
        }
        return detail.isEmpty ? name : "\(name) \(detail)"
    }
}
