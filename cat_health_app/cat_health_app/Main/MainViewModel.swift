//
//  MainViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/10.
//

import Foundation
import CoreData

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

    // MARK: - Fetch Records
    func fetchRecords(for date: Date) {
        let request: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()

        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]

        do {
            let entities = try context.fetch(request)
            records = entities.map { entity in
                CatRecord(
                    time: timeFormatter(date: entity.time ?? Date()),
                    content: formatContent(name: entity.categoryName ?? "", detail: entity.detail),
                    iconName: entity.iconName ?? "questionmark"
                )
            }
        } catch {
            print("❌ 記録の取得に失敗: \(error.localizedDescription)")
            records = []
        }
    }

    private func formatContent(name: String, detail: String?) -> String {
        if name == "日記" {
            return "日記"
        }
        if let detail = detail, !detail.isEmpty {
            return "\(name) \(detail)"
        } else {
            return name
        }
    }

    // MARK: - Add Record (main method)
    func addRecord(category: RecordCategory, detail: String = "", for date: Date) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: date)

        let entity = RecordEntity(context: context)
        entity.date = startOfDay
        entity.time = now
        entity.categoryName = category.name
        entity.iconName = category.iconName
        entity.detail = detail

        do {
            try context.save()
            fetchRecords(for: date)
        } catch {
            print("❌ 記録の保存に失敗: \(error.localizedDescription)")
        }
    }

    // MARK: - Add Record (simple version)
    func addRecord(category: RecordCategory) {
        addRecord(category: category, detail: "", for: Date())
    }

    // MARK: - Time Formatter
    private func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
