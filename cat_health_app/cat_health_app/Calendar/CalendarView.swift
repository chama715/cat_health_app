//
//  CalendarView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/12.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var showTimelineModal = false
    @State private var alreadyShown = false  // ← 追加

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
                    Text("カレンダー")
                        .font(.custom("Jiyucho", size: 28))
                        .padding(.top, 20)
                    
                    // カレンダー表示
                    DatePicker("日付を選択", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .onChange(of: viewModel.selectedDate) { _ in
                            viewModel.fetchRecordsForSelectedDate()
                            showTimelineModal = true
                        }
                        .padding()
                    
                    Spacer()
                }
                .frame(width: 400)
                .padding()
                .onAppear {
                    // 表示されたときに初期値でモーダルを1回だけ表示
                    if !alreadyShown {
                        alreadyShown = true
                        viewModel.fetchRecordsForSelectedDate()
                        showTimelineModal = true
                    }
                }

                // モーダル表示
                .sheet(isPresented: $showTimelineModal) {
                    TimelineModalView(records: viewModel.records, selectedDate: viewModel.selectedDate)
                }
            }
        }
    }
}
