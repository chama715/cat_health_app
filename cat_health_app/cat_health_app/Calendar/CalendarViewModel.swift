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

    // MARK: - 日本時間に合わせる
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        return cal
    }

    // MARK: - 記録を読み込む関数
    func fetchRecordsForSelectedDate() {
        guard let catUUID = UUID(uuidString: selectedCatID) else {
            records = []
            return
        }

        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "catID == %@ AND date >= %@ AND date < %@",
            catUUID as CVarArg, startOfDay as NSDate, endOfDay as NSDate
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        do {
            records = try context.fetch(fetchRequest)
        } catch {
            records = []
        }
    }
}
