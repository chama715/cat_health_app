//
//  Model.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/12.
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

class NavigationModel: ObservableObject {
    @Published var path = NavigationPath()
}
