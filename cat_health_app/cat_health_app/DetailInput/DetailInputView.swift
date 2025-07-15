//
//  DetailInputView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/11.
//

import SwiftUI

struct DetailInputView: View {
    let RecordCategory: RecordCategory
    let recordDate: Date
    var onSave: (String, Date) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var detailText: String = ""
    @State private var selectedPoop = "普通"
    @State private var gramText: String = ""
    @State private var selectedCondition = "普通"
    @State private var diaryText: String = ""
    @State private var weightText: String = ""

    let poopOptions = ["硬め", "普通", "柔らかめ", "下痢"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("詳細入力：\(RecordCategory.name)")
                    .font(.custom("Jiyucho", size: 20))
                
                if RecordCategory.name == "うんち" {
                    Picker("状態を選択", selection: $selectedPoop) {
                        ForEach(poopOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding()

                    Button("保存") {
                        onSave(selectedPoop, recordDate)
                        dismiss()
                    }
                    .font(.custom("Jiyucho", size: 20))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                } else if RecordCategory.name == "ごはん" {
                    TextField("g数を入力（任意）", text: $gramText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("保存") {
                        let textToSave = gramText.isEmpty ? "" : "\(gramText)g"
                        onSave(textToSave, recordDate)
                        dismiss()
                    }
                    .font(.custom("Jiyucho", size: 20))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                } else if RecordCategory.name == "体重" {
                    TextField("体重を入力（例: 4.2）", text: $weightText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Text("単位：kg")
                        .font(.custom("Jiyucho", size: 14))
                        .foregroundColor(.gray)

                    Button("保存") {
                        let textToSave = weightText.isEmpty ? "" : weightText
                        onSave(textToSave, recordDate)
                        dismiss()
                    }
                    .font(.custom("Jiyucho", size: 20))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                } else if RecordCategory.name == "日記" {
                    TextEditor(text: $diaryText)
                        .frame(height: 200)
                        .border(Color.gray.opacity(0.5), width: 1)
                        .padding()

                    Button("保存") {
                        onSave(diaryText, recordDate)
                        dismiss()
                    }
                    .font(.custom("Jiyucho", size: 20))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                } else {
                    TextField("詳細を入力", text: $detailText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("保存") {
                        onSave(detailText, recordDate)
                        dismiss()
                    }
                    .font(.custom("Jiyucho", size: 20))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .padding()
            .navigationTitle("詳細入力")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
}
