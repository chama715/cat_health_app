//
//  cat_health_appApp.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

import SwiftUI

@main
struct cat_health_appApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var navigationModel = NavigationModel()

    var body: some Scene {
        WindowGroup {
            TitleView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(navigationModel) // ← 忘れずに！
        }
    }
}
