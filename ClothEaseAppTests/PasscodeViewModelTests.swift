//
//  PasscodeViewModelTests.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import XCTest
@testable import ClothEaseApp

final class PasscodeViewModelTests: XCTestCase {

    func testCorrectPasscodeUnlocks() {
        let viewModel = PasscodeViewModel()
        viewModel.handleInput("1")
        viewModel.handleInput("2")
        viewModel.handleInput("3")
        viewModel.handleInput("4")
        XCTAssertTrue(viewModel.isUnlocked)
    }

    func testIncorrectPasscodeResetsInput() {
        let viewModel = PasscodeViewModel()
        viewModel.handleInput("1")
        viewModel.handleInput("2")
        viewModel.handleInput("3")
        viewModel.handleInput("9") // wrong last digit
        XCTAssertEqual(viewModel.input, "") // should reset
        XCTAssertFalse(viewModel.isUnlocked)
    }

    func testDeleteLastDigit() {
        let viewModel = PasscodeViewModel()
        viewModel.handleInput("1")
        viewModel.handleInput("2")
        viewModel.deleteLast()
        XCTAssertEqual(viewModel.input, "1")
    }
}
