//
//  CatRegisterViewModel.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//
import SwiftUI
import PhotosUI

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


    // 後で Firebase / CoreData に保存処理へ拡張
    func registerCat() {
        let ageComponents = calculateAgeComponents()
        print("名前: \(catName), 性別: \(gender), 猫種: \(breed), 年齢: \(ageComponents.year ?? 0)歳\(ageComponents.month ?? 0)ヶ月, 生年月日: \(birthDate)")
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
}
