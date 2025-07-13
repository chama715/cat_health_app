//
//  CalendarView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/12.
//

import SwiftUI
import CoreData

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            DatePicker("日付を選択", selection: $viewModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()

            Divider()

            if let record = viewModel.dailyRecord {
                VStack(alignment: .leading, spacing: 8) {
                    Text("ごはん：\(record.foodAmount) g")
                    Text("うんち：\(record.poopStatus ?? "未記録")")
                    Text("体調：\(record.condition ?? "未記録")")
                    Text("日記：\(record.memo ?? "未記録")")
                }
                .padding()
            } else {
                Text("この日の記録はありません")
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .navigationTitle("カレンダー")
        .padding()
        .onAppear {
            viewModel.fetchRecordForSelectedDate()
        }
        .onChange(of: viewModel.selectedDate) { _ in
            viewModel.fetchRecordForSelectedDate()
        }
    }
}

#Preview {
    CalendarView()
}
