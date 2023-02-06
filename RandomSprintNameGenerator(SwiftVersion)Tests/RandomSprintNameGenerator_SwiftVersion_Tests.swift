//
//  RandomSprintNameGenerator_SwiftVersion_Tests.swift
//  RandomSprintNameGenerator(SwiftVersion)Tests
//
//  Created by Yannick Brands on 15.12.22.
//

import XCTest
@testable import RandomSprintNameGenerator_SwiftVersion_

final class RandomSprintNameGenerator_SwiftVersion_Tests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        let randomWordFetcher = RandomWordFetcher()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateURL() throws {
        let randomWordFetcher = RandomWordFetcher()
        let expectedURL = "https://random-word-form.herokuapp.com/random/noun/a?count=3"
        randomWordFetcher.getRandomWords(firstLetter: "a", wordCount: "3")
        XCTAssertEqual(createdURL, expectedURL)
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
