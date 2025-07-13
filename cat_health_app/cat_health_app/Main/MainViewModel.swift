//
//  MainViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/10.
//

import SwiftUI
import CoreData
import Foundation

class MainViewModel: ObservableObject {
    @Published var records: [CatRecord] = []

    let categories: [RecordCategory] = [
            RecordCategory(name: "おしっこ", iconName: "toilet", requiresDetail: false),
            RecordCategory(name: "うんち", iconName: "toilet.fill", requiresDetail: true),
            RecordCategory(name: "ごはん", iconName: "frying.pan", requiresDetail: true),
            RecordCategory(name: "おやつ", iconName: "popcorn", requiresDetail: false),
            RecordCategory(name: "水", iconName: "waterbottle", requiresDetail: false),
            RecordCategory(name: "つめきり", iconName: "scissors", requiresDetail: false),
            RecordCategory(name: "ブラシ", iconName: "paintbrush", requiresDetail: false),
            RecordCategory(name: "体調", iconName: "stethoscope", requiresDetail: true),
            RecordCategory(name: "くすり", iconName: "pills", requiresDetail: false),
            RecordCategory(name: "日記", iconName: "list.clipboard", requiresDetail: true),
            RecordCategory(name: "猫選択", iconName: "pawprint.circle", requiresDetail: true),
            RecordCategory(name: "設定", iconName: "gearshape", requiresDetail: true),
        ]

    private let context = PersistenceController.shared.container.viewContext

    func fetchRecords(for date: Date) {
        let request: NSFetchRequest<DailyRecordEntity> = DailyRecordEntity.fetchRequest()

        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)

        do {
            let result = try context.fetch(request)
            guard let entity = result.first else {
                records = []
                return
            }

            var temp: [CatRecord] = []

            let timeString = timeFormatter(date: entity.date ?? date)

            if entity.foodAmount > 0 {
                temp.append(CatRecord(time: timeString, content: "ごはん \(entity.foodAmount)g", iconName: "frying.pan"))
            }

            if let poop = entity.poopStatus, !poop.isEmpty {
                temp.append(CatRecord(time: timeString, content: "うんち \(poop)", iconName: "toilet.fill"))
            }

            if let cond = entity.condition, !cond.isEmpty {
                temp.append(CatRecord(time: timeString, content: "体調 \(cond)", iconName: "stethoscope"))
            }

            if let memo = entity.memo, !memo.isEmpty {
                temp.append(CatRecord(time: timeString, content: "日記: \(memo)", iconName: "list.clipboard"))
            }

            records = temp
        } catch {
            print("❌ 記録の取得に失敗: \(error.localizedDescription)")
            records = []
        }
    }

    private func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    func addRecord(category: RecordCategory) {
        let timeString = timeFormatter(date: Date())

        let newRecord = CatRecord(
            time: timeString,
            content: category.name,
            iconName: category.iconName
        )
        records.append(newRecord)
    }

    func addRecord(category: RecordCategory, detail: String) {
        let timeString = timeFormatter(date: Date())
        let contentText = detail.isEmpty ? category.name : "\(category.name) \(detail)"

        let newRecord = CatRecord(
            time: timeString,
            content: contentText,
            iconName: category.iconName
        )
        records.append(newRecord)
    }
}
