//
//  CalendarViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/12.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var records: [RecordEntity] = []

    private let context = PersistenceController.shared.container.viewContext

    @AppStorage("selectedCatID") private var selectedCatID: String = ""

    func fetchRecordsForSelectedDate() {
        guard let catUUID = UUID(uuidString: selectedCatID) else {
            print("⚠️ 選択されたペットIDが不正です")
            records = []
            return
        }

        // ✅ タイムゾーンを「Asia/Tokyo」に設定したカレンダーを使用
        var jstCalendar = Calendar.current
        jstCalendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!

        let startOfDay = jstCalendar.startOfDay(for: selectedDate)
        let endOfDay = jstCalendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "catID == %@ AND date >= %@ AND date < %@",
            catUUID as CVarArg, startOfDay as NSDate, endOfDay as NSDate
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]

        do {
            records = try context.fetch(fetchRequest)
            print("📅 \(selectedDate) の記録件数: \(records.count)")
        } catch {
            print("❌ 記録取得に失敗: \(error.localizedDescription)")
            records = []
        }
    }
}
