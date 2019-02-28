//
//  NetworkUtils_ExampleUITests.swift
//  NetworkUtils_ExampleUITests
//
//  Created by Wyatt Mufson on 2/27/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

class NetworkUtils_ExampleUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoading() {
        let expectation = XCTestExpectation(description: "Test loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.1)
    }
}
