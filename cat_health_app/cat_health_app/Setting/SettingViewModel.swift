//
//  SettingViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/13.
//

import Foundation
import CoreData

class SettingViewModel: ObservableObject {
    private let context = PersistenceController.shared.container.viewContext
    
    // 全てのタイムライン情報を削除するための関数
    func deleteAllRecords() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RecordEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("✅ 全ての記録を削除しました")
        } catch {
            print("❌ 削除に失敗: \(error.localizedDescription)")
        }
    }
    
    // 全ての猫情報を削除する関数
    func deleteAllCats() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CatEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("✅ 全てのペット情報を削除しました")
        } catch {
            print("❌ ペット情報の削除に失敗: \(error.localizedDescription)")
        }
    }
    
    // 上記2つの関数を同時に発動させ、全データを削除
    func deleteAllData() {
        deleteAllRecords()
        deleteAllCats()
        print("✅ 全てのデータ（記録・ペット情報）を削除しました")
    }
    
    // 個別削除の関数
    func deleteCatAndRecords(catID: UUID) {
        let recordRequest: NSFetchRequest<NSFetchRequestResult> = RecordEntity.fetchRequest()
        recordRequest.predicate = NSPredicate(format: "catID == %@", catID as CVarArg)
        let deleteRecords = NSBatchDeleteRequest(fetchRequest: recordRequest)
        
        let catRequest: NSFetchRequest<NSFetchRequestResult> = CatEntity.fetchRequest()
        catRequest.predicate = NSPredicate(format: "id == %@", catID as CVarArg)
        let deleteCat = NSBatchDeleteRequest(fetchRequest: catRequest)
        
        do {
            try context.execute(deleteRecords)
            try context.execute(deleteCat)
            try context.save()
            print("✅ \(catID) の情報と記録を削除しました")
        } catch {
            print("❌ 削除に失敗: \(error.localizedDescription)")
        }
    }
}

