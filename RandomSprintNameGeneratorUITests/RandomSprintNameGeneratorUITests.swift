//
//  RandomSprintNameGeneratorUITests.swift
//  RandomSprintNameGeneratorUITests
//
//  Created by Yannick Brands on 15.02.23.
//

import XCTest

final class RandomSprintNameGeneratorUITests: XCTestCase {

    var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    func test_SetFetchingVariables_TextFieldsAcceptOnlyValidInputsAndLenght() throws {
        app.otherElements.buttons["Nav_SetFetchingVariablesView"].tap()
        app.textFields["TextField_FirstLetter"].tap()
        app.textFields["TextField_FirstLetter"].typeText("2ab")
        XCTAssertEqual(app.textFields["TextField_FirstLetter"].value as! String, "a")
        app.textFields["TextField_WordCount"].tap()
        app.textFields["TextField_WordCount"].typeText("hg123")
        XCTAssertEqual(app.textFields["TextField_WordCount"].value as! String, "10")
        app.textFields["TextField_VoterAmount"].tap()
        app.textFields["TextField_VoterAmount"].typeText("bs1234")
        XCTAssertEqual(app.textFields["TextField_VoterAmount"].value as! String, "123")
    }
    
    func test_VotingView_CorrectAmountOfVoteCandidatesCreated() throws {
            app.otherElements.buttons["Nav_SetFetchingVariablesView"].tap()
            app.textFields["TextField_FirstLetter"].tap()
            app.textFields["TextField_FirstLetter"].typeText("a")
            app.textFields["TextField_WordCount"].tap()
            app.textFields["TextField_WordCount"].typeText("5")
            app.textFields["TextField_VoterAmount"].tap()
            app.textFields["TextField_VoterAmount"].typeText("5")
            app.otherElements.buttons["Nav_VotingView"].tap()
            sleep(2)
            XCTAssertTrue(app.buttons["Button_CastVote\(0)"].exists)
            XCTAssertTrue(app.buttons["Button_CastVote\(1)"].exists)
            XCTAssertTrue(app.buttons["Button_CastVote\(2)"].exists)
            XCTAssertTrue(app.buttons["Button_CastVote\(3)"].exists)
            XCTAssertTrue(app.buttons["Button_CastVote\(4)"].exists)
            XCTAssertFalse(app.buttons["Button_CastVote\(5)"].exists)
    }
    
    func test_ContentView_AllViewsReachable() throws {
        app.otherElements.buttons["Nav_SetFetchingVariablesView"].tap()
        XCTAssertTrue(app.textFields["TextField_FirstLetter"].exists)
        app.otherElements.buttons["Nav_Imprint"].tap()
        XCTAssertTrue(app.staticTexts["API used for the random names:\nhttps://random-word-form.herokuapp.com"].exists)
        app.otherElements.buttons["Nav_PreviousSprintNamesListView"].tap()
        app.otherElements.buttons.element(boundBy: 3).tap()
        XCTAssertTrue(app.otherElements.images["Img_Calendar"].exists)
    }
    
    func test_VoteResultView_CalledAsExpected() throws {
        app.otherElements.buttons["Nav_SetFetchingVariablesView"].tap()
        app.textFields["TextField_FirstLetter"].tap()
        app.textFields["TextField_FirstLetter"].typeText("a")
        app.textFields["TextField_WordCount"].tap()
        app.textFields["TextField_WordCount"].typeText("5")
        app.textFields["TextField_VoterAmount"].tap()
        app.textFields["TextField_VoterAmount"].typeText("5")
        app.otherElements.buttons["Nav_VotingView"].tap()
        sleep(2)
        app.buttons["Button_CastVote\(0)"].tap()
        app.buttons["Button_CastVote\(0)"].tap()
        app.buttons["Button_CastVote\(2)"].tap()
        app.buttons["Button_CastVote\(2)"].tap()
        app.buttons["Button_CastVote\(3)"].tap()
        app.buttons["Button_ShowVotingResults"].tap()
        XCTAssertTrue(app.buttons["Button_TiebreakerVote"].exists)
        app.buttons["Button_TiebreakerVote"].tap()
        XCTAssertTrue(app.buttons["Button_CastVote\(0)"].exists)
        XCTAssertTrue(app.buttons["Button_CastVote\(1)"].exists)
        XCTAssertFalse(app.buttons["Button_CastVote\(2)"].exists)
        app.buttons["Button_CastVote\(0)"].tap()
        app.buttons["Button_CastVote\(0)"].tap()
        app.buttons["Button_CastVote\(0)"].tap()
        app.buttons["Button_CastVote\(0)"].tap()
        app.buttons["Button_CastVote\(0)"].tap()
        app.buttons["Button_ShowVotingResults"].tap()
        XCTAssertTrue(app.buttons["Button_SaveAndExit"].exists)
    }
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
