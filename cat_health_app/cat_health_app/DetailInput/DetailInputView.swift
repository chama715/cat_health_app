//
//  DetailInputView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/11.
//

import SwiftUI

struct DetailInputView: View {
    let RecordCategory: RecordCategory
    var onSave: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var detailText: String = ""
    @State private var selectedPoop = "普通"
    @State private var gramText: String = ""
    @State private var selectedCondition = "普通"
    @State private var diaryText: String = ""

    let poopOptions = ["硬め", "普通", "柔らかめ", "下痢"]
    let conditionOptions = ["良い", "普通", "悪い"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("詳細入力：\(RecordCategory.name)")
                    .font(.title2)
                    .bold()
                
                if RecordCategory.name == "うんち" {
                    Picker("状態を選択", selection: $selectedPoop) {
                        ForEach(poopOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding()

                    Button("保存") {
                        onSave(selectedPoop)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.softTiffany)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                } else if RecordCategory.name == "ごはん" {
                    TextField("g数を入力（任意）", text: $gramText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("保存") {
                        let textToSave = gramText.isEmpty ? "" : "\(gramText)g"
                        onSave(textToSave)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.softTiffany)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                } else if RecordCategory.name == "体調" {
                    Picker("体調を選択", selection: $selectedCondition) {
                        ForEach(conditionOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding()

                    Button("保存") {
                        onSave(selectedCondition)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.softTiffany)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                } else if RecordCategory.name == "日記" {
                    TextEditor(text: $diaryText)
                        .frame(height: 200)
                        .border(Color.gray.opacity(0.5), width: 1)
                        .padding()

                    Button("保存") {
                        onSave(diaryText)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.softTiffany)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                } else {
                    TextField("詳細を入力", text: $detailText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("保存") {
                        onSave(detailText)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.softTiffany)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
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

#Preview {
    DetailInputView(RecordCategory: RecordCategory(name: "日記", iconName: "list.clipboard", requiresDetail: true)) { _ in }
}
