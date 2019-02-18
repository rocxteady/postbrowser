//
//  PostBrowserTests.swift
//  PostBrowserTests
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import XCTest
@testable import PostBrowser

class PostBrowserTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let testExpectation = expectation(description: "Request")
        let request = NetworkRequest<[Post]>()
        request.path = "/posts"
        request.start { (posts, error) in
            if let error = error {
                XCTAssert(false, error.localizedDescription)
            }
            else if posts == nil {
                XCTAssert(false, "Expected Data!")
            }
            else {
                XCTAssert(true)
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
