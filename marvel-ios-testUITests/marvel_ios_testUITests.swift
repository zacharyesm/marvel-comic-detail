//
//  marvel_ios_testUITests.swift
//  marvel-ios-testUITests
//
//  Created by Zachary Esmaelzada on 3/18/20.
//  Copyright © 2020 Zachary Esmaelzada. All rights reserved.
//

import XCTest

class marvel_ios_testUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let readNowButton = app.scrollViews.otherElements.buttons["READ NOW"]
        let readNowAlert = app.alerts["Read Now"].scrollViews.otherElements.buttons["Ok"]
        
        XCTAssertTrue(readNowButton.exists)
        readNowButton.tap()
        XCTAssertTrue(readNowAlert.exists)
        readNowAlert.tap()
        XCTAssertTrue(!readNowAlert.exists)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
