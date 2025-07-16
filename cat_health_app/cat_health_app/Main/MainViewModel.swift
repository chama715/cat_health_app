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
    // 表示する記録を格納しておく状態
    @Published var records: [CatRecord] = []
    
    // 下部に並ぶタイルのそれぞれの定義（詳細情報の入力が必要なものはtrue）
    let categories: [RecordCategory] = [
        RecordCategory(name: "おしっこ", iconName: "toilet", requiresDetail: false),
        RecordCategory(name: "うんち", iconName: "toilet.fill", requiresDetail: true),
        RecordCategory(name: "ごはん", iconName: "frying.pan", requiresDetail: true),
        RecordCategory(name: "おやつ", iconName: "popcorn", requiresDetail: false),
        RecordCategory(name: "水", iconName: "waterbottle", requiresDetail: false),
        RecordCategory(name: "つめきり", iconName: "scissors", requiresDetail: false),
        RecordCategory(name: "ブラシ", iconName: "paintbrush", requiresDetail: false),
        RecordCategory(name: "体重", iconName: "scalemass", requiresDetail: true),
        RecordCategory(name: "くすり", iconName: "pills", requiresDetail: false),
        RecordCategory(name: "日記", iconName: "list.clipboard", requiresDetail: true),
        RecordCategory(name: "猫選択", iconName: "pawprint.circle", requiresDetail: true),
        RecordCategory(name: "設定", iconName: "gearshape", requiresDetail: true),
    ]
    
    private let context = PersistenceController.shared.container.viewContext
    @AppStorage("selectedCatID") private var selectedCatID: String = ""
    
    // 日本用のカレンダーに変換（アメリカ時間にならないため）
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        return cal
    }
    
    // 猫データを取得してViewに表示させるための関数
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
                    content: formatContent(name: entity.categoryName ?? "", detail: entity.detail ?? ""),
                    iconName: entity.iconName ?? "questionmark",
                    detail: entity.detail ?? ""
                )
            }
        } catch {
            print("❌ 記録の取得に失敗: \(error.localizedDescription)")
            records = []
        }
    }
    
    // タイムラインから記録を削除する処理
    func deleteRecord(_ record: CatRecord) {
        guard let catUUID = UUID(uuidString: selectedCatID) else {
            print("⚠️ selectedCatIDが不正です")
            return
        }

        let request: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "catID == %@ AND iconName == %@ AND time >= %@ AND time <= %@",
            catUUID as CVarArg,
            record.iconName as CVarArg,
            startOfDay(for: record.time) as CVarArg,
            endOfDay(for: record.time) as CVarArg
        )

        do {
            let results = try context.fetch(request)
            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
                print("🗑️ 記録を削除しました: \(record.content)")
            } else {
                print("⚠️ 該当する記録が見つかりませんでした")
            }
        } catch {
            print("❌ 記録の削除に失敗: \(error.localizedDescription)")
        }
    }

    // 指定時刻の0時
    private func startOfDay(for timeString: String) -> Date {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "HH:mm"
        guard let time = formatter.date(from: timeString) else { return now }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let today = calendar.startOfDay(for: now)
        return calendar.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: 0, of: today)!
    }

    private func endOfDay(for timeString: String) -> Date {
        return calendar.date(byAdding: .minute, value: 1, to: startOfDay(for: timeString))!
    }

    
    
    // CoreDataに保存する処理
    func addRecord(category: RecordCategory, detail: String = "", for date: Date) {
        guard let uuid = UUID(uuidString: selectedCatID) else {
            print("⚠️ selectedCatIDが不正 or 未設定")
            return
        }
        
        let recordDate = calendar.startOfDay(for: date)
        let recordTime = Date()
        
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
    
    // CoreDataに保存する処理
    func addRecord(category: RecordCategory, for date: Date) {
        addRecord(category: category, detail: "", for: date)
    }
    
    // タイムラインに表示するテキストの処理
    private func formatContent(name: String, detail: String?) -> String {
        if name == "日記" {
            return "日記"
        }
        if name == "体重", let detail = detail, !detail.isEmpty {
            return "体重 \(detail)kg"
        }
        if let detail = detail, !detail.isEmpty {
            return "\(name) \(detail)"
        } else {
            return name
        }
    }
    
    // 時間の表示を変更
    private func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    // 年月日の表示を変更
    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // ログ出力などで正確な日時を表示するための処理
    private func formatJST(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        return formatter.string(from: date)
    }
    
    // 1年以上前のデータを削除する処理
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
