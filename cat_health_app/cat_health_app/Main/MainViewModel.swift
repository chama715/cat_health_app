//
//  MainViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/10.
//

import SwiftUI

struct CatRecord: Identifiable {
    let id = UUID()
    let time: String
    let content: String
    let iconName: String
}

struct RecordCategory: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let requiresDetail: Bool
}

class MainViewModel: ObservableObject {
    @Published var records: [CatRecord] = [
        CatRecord(time: "09:00", content: "ごはん 食べた", iconName: "fork.knife"),
        CatRecord(time: "11:00", content: "おしっこ 出た", iconName: "drop.fill"),
        CatRecord(time: "12:30", content: "うんち ふつう", iconName: "tortoise.fill")
    ]
    
    let categories: [RecordCategory] = [
        RecordCategory(name: "おしっこ", iconName: "toilet", requiresDetail: false),
        RecordCategory(name: "うんち", iconName: "toilet.fill", requiresDetail: true),
        RecordCategory(name: "ごはん", iconName: "frying.pan", requiresDetail: true),
        RecordCategory(name: "おやつ", iconName: "popcorn", requiresDetail: false),
        RecordCategory(name: "水", iconName: "waterbottle", requiresDetail: false),
        RecordCategory(name: "つめきり", iconName: "scissors", requiresDetail: false),
        RecordCategory(name: "ブラッシング", iconName: "paintbrush", requiresDetail: false),
        RecordCategory(name: "体調", iconName: "stethoscope", requiresDetail: true),
        RecordCategory(name: "くすり", iconName: "pills", requiresDetail: false),
        RecordCategory(name: "日記", iconName: "list.clipboard", requiresDetail: true)
    ]
    
    func addRecord(category: RecordCategory) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: Date())
        
        let newRecord = CatRecord(
            time: timeString,
            content: category.name, // 表示名だけで統一
            iconName: category.iconName
        )
        
        records.append(newRecord)
    }
}
