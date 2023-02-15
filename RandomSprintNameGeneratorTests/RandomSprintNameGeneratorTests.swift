//
//  RandomSprintNameGenerator_SwiftVersion_Tests.swift
//  RandomSprintNameGenerator(SwiftVersion)Tests
//
//  Created by Yannick Brands on 15.12.22.
//

import XCTest
@testable import RandomSprintNameGenerator

final class RandomSprintNameGeneratorTests: XCTestCase {

    var underTest: RandomWordFetcher!
    var goodJsonData: Data!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let jsonURL = Bundle(for: type(of: self)).url(forResource: "API_goodResponse", withExtension: "json")
        goodJsonData = try Data(contentsOf: jsonURL!)
        underTest = RandomWordFetcher()
        URLStubbing.stubSchemes.append("https")
        URLStubbing.register()
    }

    override func tearDownWithError() throws {
        URLStubbing.unregister()
        try super.tearDownWithError()
    }
    
    func test_getRandomWords_CreatesRandomWordArrayCorrectly() throws {
        
        let gotWords = expectation(description: "received random words")
        gotWords.expectedFulfillmentCount = 2
        let subber = underTest.$randomWords.sink { _ in
            gotWords.fulfill()
        }
        defer { subber.cancel() }
        URLStubbing.stubResponseAndData = { [unowned self] request in
            print("got it")
            return (URLStubbing.simple200Response(for: request), goodJsonData)
        }
        underTest.getRandomWords(firstLetter: "a", wordCount: "5")
        
        wait(for: [gotWords], timeout: 3.0)
        let foundwords = underTest.randomWords.map { $0.randomWord }
        XCTAssertEqual(foundwords, ["accuracy", "anwser", "abbey", "adaptation", "anchor"])
        underTest.randomWords.forEach { XCTAssertEqual($0.voteCount, 0) }
//        let jsonString = "[\"accuracy\", \"anwser\", \"abbey\", \"adaptation\", \"anchor\"]".data(using: .utf8)
    }

    func test_isReadyToFetch_BoolGetsSetCorrectly () throws {
        XCTAssertEqual(underTest.isReadyToFetch, false)
        underTest.firstLetter = "a"
        underTest.wordCount = "4"
        underTest.voterAmount = "4"
        XCTAssertEqual(underTest.isReadyToFetch, true)
        underTest.firstLetter = ""
        XCTAssertEqual(underTest.isReadyToFetch, false)
        underTest.firstLetter = "f"
        underTest.wordCount = "Wrong input, will default to two"
        XCTAssertEqual(underTest.isReadyToFetch, true)
    }

    func test_prepForTiebreaker_changesArrayCorrectly () throws {
        //testing to see if prepForTiebreaker filters correctly by maximum votecount and resets votecount to 0 afterwards
        let testElement1 = RandomWordFetcher.RandomWordElement(randomWord: "a", voteCount: 5)
        let testElement2 = RandomWordFetcher.RandomWordElement(randomWord: "b", voteCount: 1)
        let testElement3 = RandomWordFetcher.RandomWordElement(randomWord: "c", voteCount: 5)
        let testElement4 = RandomWordFetcher.RandomWordElement(randomWord: "d", voteCount: 1)
        underTest.randomWords = [testElement1, testElement2, testElement3, testElement4]
        underTest.prepForTiebreaker(topVoteCount: 5)
        XCTAssertEqual(underTest.randomWords.count, 2)
        XCTAssertEqual(underTest.randomWords[0].voteCount, 0)
        XCTAssertEqual(underTest.randomWords[0].randomWord, "a")
        XCTAssertEqual(underTest.randomWords[1].voteCount, 0)
        XCTAssertEqual(underTest.randomWords[1].randomWord, "c")
    }
    
    func test_getRandomWords_errorHandling_NoInternetError () throws {
        
        let failed = expectation(description: "Did receive error")
        underTest.errorCallback = { error in
            print(error)
            XCTAssertEqual((error as NSError).code, NSURLErrorNotConnectedToInternet)
            failed.fulfill()
        }
        URLStubbing.stubError = URLStubbing.simpleNoInternetError
        underTest.getRandomWords(firstLetter: "a", wordCount: "4")
        wait(for: [failed], timeout: 3.0)
    }
    
    func test_getRandomWords_errorHandling_BadDatasetFetched () throws {
        
        let badData = Data()
        let failed = expectation(description: "Did receive error")
        underTest.errorCallback = { error in
            print(error)
            XCTAssertEqual((error as NSError).code, 4864)
            failed.fulfill()
        }
        URLStubbing.stubResponseAndData = { request in
            print("got it")
            return (URLStubbing.simple200Response(for: request), badData)
        }
        underTest.getRandomWords(firstLetter: "a", wordCount: "5")
        
        wait(for: [failed], timeout: 3.0)
    }
    
    func test_getRandomWords_errorHandling_BadStatusCode () throws {
        
        let failed = expectation(description: "Did receive error")
        underTest.errorCallback = { error in
            print(error)
            XCTAssertEqual(error as! RandomWordFetcher.ResponseError, RandomWordFetcher.ResponseError.badStatusCode)
            failed.fulfill()
        }
        URLStubbing.stubResponseAndData = URLStubbing.simple401Response
        underTest.getRandomWords(firstLetter: "a", wordCount: "4")
        wait(for: [failed], timeout: 3.0)
    }
    
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
