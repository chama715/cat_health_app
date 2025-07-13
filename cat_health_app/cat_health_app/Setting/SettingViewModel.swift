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

    func deleteAllData() {
        deleteAllRecords()
        deleteAllCats()
        print("✅ 全てのデータ（記録・ペット情報）を削除しました")
    }

    
}

