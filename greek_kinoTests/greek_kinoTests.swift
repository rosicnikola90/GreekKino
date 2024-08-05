//
//  greek_kinoTests.swift
//  greek_kinoTests
//
//  Created by Nikola Rosic on 2.8.24..
//

import XCTest
@testable import greek_kino

final class greek_kinoTests: XCTestCase {
    
    final class CountdownViewModelTests: XCTestCase {

        func testUpdateTimeRemaining_whenTimeIsInTheFuture() {
            // Given
            let futureDate = Date().addingTimeInterval(3600) // 1 hour in the future
            let viewModel = CountdownViewModel(drawTime: Int(futureDate.timeIntervalSince1970 * 1000))
            
            // When
            viewModel.updateTimeRemaining(currentDate: Date())
            
            // Then
            XCTAssertEqual(viewModel.reachedZero, false)
            XCTAssertEqual(viewModel.isBelowTwoMinute, false)
            XCTAssertFalse(viewModel.timeRemaining.isEmpty)
        }
        
        func testUpdateTimeRemaining_whenTimeIsNowOrWithinLastThreeMinutes() {
            // Given
            let now = Date()
            let viewModel = CountdownViewModel(drawTime: Int(now.addingTimeInterval(100).timeIntervalSince1970 * 1000)) // 100 seconds in the future
            
            // When
            viewModel.updateTimeRemaining(currentDate: now)
            
            // Then
            XCTAssertEqual(viewModel.reachedZero, false)
            XCTAssertEqual(viewModel.isBelowTwoMinute, true)
        }

        func testUpdateTimeRemaining_whenTimeIsInThePast() {
            // Given
            let pastDate = Date().addingTimeInterval(-3600) // 1 hour in the past
            let viewModel = CountdownViewModel(drawTime: Int(pastDate.timeIntervalSince1970 * 1000))
            
            // When
            viewModel.updateTimeRemaining(currentDate: Date())
            
            // Then
            XCTAssertEqual(viewModel.reachedZero, true)
            XCTAssertEqual(viewModel.timeRemaining, "00:00")
            XCTAssertEqual(viewModel.isBelowTwoMinute, false)
        }
    }

}
