//
//  PersistenceController.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/11.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CatHealthModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("❌ Unresolved error \(error), \(error.userInfo)")
            } else {
                print("🐾 CoreData Store loaded at: \(description.url?.absoluteString ?? "unknown")")
            }
        }
    }
}

