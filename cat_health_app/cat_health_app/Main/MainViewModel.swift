//
//  MainViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/10.
//

import Foundation
import CoreData
import SwiftUI

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
    @AppStorage("selectedCatID") private var selectedCatID: String = ""

    // ✅ JST固定カレンダー
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        return cal
    }

    // MARK: - Fetch Records
    func fetchRecords(for date: Date) {
        guard let catUUID = UUID(uuidString: selectedCatID) else {
            print("⚠️ selectedCatIDが不正です")
            records = []
            return
        }

        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            records = []
            return
        }

        // ✅ JST表示に修正
        print("🔍 検索範囲: \(formatJST(startOfDay)) 〜 \(formatJST(endOfDay))")

        let request: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "catID == %@ AND date >= %@ AND date < %@",
            catUUID as CVarArg, startOfDay as NSDate, endOfDay as NSDate
        )
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]

        do {
            let entities = try context.fetch(request)
            print("📥 \(formatted(date: startOfDay)) の記録件数: \(entities.count)")
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

    // MARK: - Add Record
    func addRecord(category: RecordCategory, detail: String = "", for date: Date) {
        guard let uuid = UUID(uuidString: selectedCatID) else {
            print("⚠️ selectedCatIDが不正 or 未設定")
            return
        }

        let recordDate = calendar.startOfDay(for: date)
        let recordTime = Date()

        // ✅ JST表示に修正
        print("📝 保存される日付: \(formatJST(recordDate))")

        let entity = RecordEntity(context: context)
        entity.date = recordDate
        entity.time = recordTime
        entity.categoryName = category.name
        entity.iconName = category.iconName
        entity.detail = detail
        entity.setValue(uuid, forKey: "catID")

        print("🐾 保存: \(category.name) \(detail) @ \(formatted(date: recordDate))")

        do {
            try context.save()
            deleteOldRecords(olderThan: 365)
            fetchRecords(for: date)
        } catch {
            print("❌ 記録の保存に失敗: \(error.localizedDescription)")
        }
    }

    func addRecord(category: RecordCategory, for date: Date) {
        addRecord(category: category, detail: "", for: date)
    }

    // MARK: - 表示フォーマット系
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

    private func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // ✅ JSTのログ出力用
    private func formatJST(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        return formatter.string(from: date)
    }

    // MARK: - 古い記録の削除
    func deleteOldRecords(olderThan days: Int) {
        let cutoffDate = calendar.date(byAdding: .day, value: -days, to: Date())!

        let request: NSFetchRequest<NSFetchRequestResult> = RecordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date < %@", cutoffDate as NSDate)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("🗑️ \(days)日より前の記録を削除しました")
        } catch {
            print("❌ 古い記録の削除に失敗: \(error.localizedDescription)")
        }
    }
}
