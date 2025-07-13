//
//  CalendarViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/12.
//

import Foundation
import CoreData

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var dailyRecord: DailyRecordEntity? = nil
    
    private let context = PersistenceController.shared.container.viewContext
    
    func fetchRecordForSelectedDate() {
        let fetchRequest: NSFetchRequest<DailyRecordEntity> = DailyRecordEntity.fetchRequest()

        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)

        do {
            let result = try context.fetch(fetchRequest)
            dailyRecord = result.first
        } catch {
            print("❌ 日付の記録取得に失敗: \(error.localizedDescription)")
        }
    }
}
