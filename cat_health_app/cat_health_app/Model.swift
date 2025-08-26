//
//  Model.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/12.
//

import SwiftUI

// 猫の情報
struct CatRecord: Identifiable {
    let id = UUID()
    let time: String
    let content: String
    let iconName: String
    let detail: String
}

// 記録の種類
struct RecordCategory: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let requiresDetail: Bool
}

// 画面遷移
class NavigationModel: ObservableObject {
    @Published var path = NavigationPath()
}
