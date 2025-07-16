//
//  CatHealthTests.swift
//  CatHealthTests
//
//  Created by 高橋直斗 on 2025/07/16.
//

import XCTest
@testable import cat_health_app

final class MainViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        let viewModel = MainViewModel()
        viewModel.deleteOldRecords(olderThan: 0)
    }

    // MARK: - AddRecordのテスト
    func testAddRecord() {
        let viewModel = MainViewModel()

        let initialCount = viewModel.records.count
        let category = viewModel.categories.first { $0.name == "おしっこ" }!
        let detail = ""
        let date = Date()

        viewModel.addRecord(category: category, detail: detail, for: date)

        XCTAssertEqual(viewModel.records.count, initialCount + 1)

        let lastRecord = viewModel.records.last
        XCTAssertEqual(lastRecord?.content, category.name)
    }

    // MARK: - fetchRecordsのテスト
    func testFetchRecords() {
        let viewModel = MainViewModel()

        let category = viewModel.categories.first { $0.name == "おしっこ" }!
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

        viewModel.addRecord(category: category, detail: "", for: today)
        viewModel.addRecord(category: category, detail: "", for: yesterday)

        viewModel.fetchRecords(for: today)

        XCTAssertEqual(viewModel.records.count, 1)
        XCTAssertEqual(viewModel.records.first?.content, category.name)
    }

    // MARK: - deleteOldRecordsのテスト
    func testDeleteOldRecords() {
        let viewModel = MainViewModel()

        let category = viewModel.categories.first { $0.name == "おしっこ" }!

        let today = Calendar.current.startOfDay(for: Date())
        let oldDate = Calendar.current.date(byAdding: .day, value: -366, to: today)!

        viewModel.addRecord(category: category, detail: "", for: today)
        viewModel.addRecord(category: category, detail: "", for: oldDate)

        viewModel.deleteOldRecords(olderThan: 365)

        viewModel.fetchRecords(for: today)

        XCTAssertEqual(viewModel.records.count, 1)
        XCTAssertEqual(viewModel.records.first?.content, category.name)
    }
}
