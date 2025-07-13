//
//  CatSelectViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/12.
//

import SwiftUI
import CoreData

@MainActor
class CatSelectViewModel: ObservableObject {
    @Published var cats: [CatEntity] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchCats()
    }

    func fetchCats() {
        let request: NSFetchRequest<CatEntity> = CatEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CatEntity.birthDate, ascending: true)]
        
        do {
            cats = try context.fetch(request)
        } catch {
            print("❌ 猫情報の取得に失敗しました: \(error.localizedDescription)")
        }
    }

    func selectCat(_ cat: CatEntity) {
        print("🐾 選択された猫: \(cat.name ?? "名前なし")")
    }

    func calculateAgeText(from birthDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: birthDate, to: Date())
        let years = components.year ?? 0
        let months = components.month ?? 0
        return "\(years)歳 \(months)ヶ月"
    }
}

