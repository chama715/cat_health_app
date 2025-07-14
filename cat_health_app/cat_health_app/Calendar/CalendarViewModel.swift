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

    // ✅ JST固定カレンダー（これがないとUTCになる！）
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        return cal
    }

    // ✅ JSTログ出力用のフォーマッタ
    private func formatJST(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        return formatter.string(from: date)
    }

    func fetchRecordsForSelectedDate() {
        guard let catUUID = UUID(uuidString: selectedCatID) else {
            print("⚠️ 選択されたペットIDが不正です")
            records = []
            return
        }

        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        // ✅ JST形式でログ出力
        print("🔍 検索範囲: \(formatJST(startOfDay)) 〜 \(formatJST(endOfDay))")

        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "catID == %@ AND date >= %@ AND date < %@",
            catUUID as CVarArg, startOfDay as NSDate, endOfDay as NSDate
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]

        do {
            records = try context.fetch(fetchRequest)
            print("📅 \(formatJST(selectedDate)) の記録件数: \(records.count)")
        } catch {
            print("❌ 記録取得に失敗: \(error.localizedDescription)")
            records = []
        }
    }
}
