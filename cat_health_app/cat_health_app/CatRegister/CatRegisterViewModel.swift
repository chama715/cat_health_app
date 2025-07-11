//
//  CatRegisterViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

/*
 Viewのロジック系をこっちに。
 登録する項目の状態を定義。
 英語っぽい生年月日を日本風に変える変数。
 登録ボタンを押した時に呼ばれる関数。
 生年月日の年、月を増やしたり減らしたりするのは別にしてUX向上。
 */

import SwiftUI
import PhotosUI
import CoreData

class CatRegisterViewModel: ObservableObject {
    @Published var catName: String = ""
    @Published var gender: String = "オス"
    @Published var breed: String = ""
    @Published var birthDate: Date = Date()
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var selectedImage: Image?

    let genders = ["オス", "メス"]
    
    var birthDateFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        return formatter.string(from: birthDate)
    }
    
    func calculateAgeComponents() -> DateComponents {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year, .month], from: birthDate, to: now)
        return ageComponents
    }

    var ageYearsText: Int {
        calculateAgeComponents().year ?? 0
    }

    var ageMonthsText: Int {
        calculateAgeComponents().month ?? 0
    }

    func loadImageFromPicker() async {
        guard let selectedPhoto else { return }
        if let data = try? await selectedPhoto.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
            await MainActor.run {
                self.selectedImage = Image(uiImage: uiImage)
            }
        }
    }

    @MainActor
    func saveCat(context: NSManagedObjectContext) {
        let newCat = CatEntity(context: context)
        newCat.id = UUID()
        newCat.name = catName
        newCat.gender = gender
        newCat.breed = breed
        newCat.birthDate = birthDate
        
        // 画像データ変換
        if let selectedImage = selectedImage {
            let renderer = ImageRenderer(content: selectedImage)
            if let uiImage = renderer.uiImage,
               let imageData = uiImage.pngData() {
                newCat.imageData = imageData
            }
        }
        
        do {
            try context.save()
            print("🐾 猫情報をCoreDataに保存しました！")
        } catch {
            print("❌ 猫情報の保存に失敗しました: \(error.localizedDescription)")
        }
    }
}
