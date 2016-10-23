//
//  STSwiftTests.swift
//  StoryTeller
//
//  Created by Derek Clarkson on 21/10/16.
//  Copyright © 2016 Derek Clarkson. All rights reserved.
//

import XCTest
@testable import StoryTeller

class STSwiftTests: XCTestCase {

    let _inMemoryLogger = InMemoryLogger()

    override func setUp() {
        STStoryTeller.instance().logger = _inMemoryLogger
    }

    override func tearDown() {
        STStoryTeller.reset()
    }

    func testBaseLogging() {
        STStartLogging("[StoryTellerTests.STSwiftTests]")
        STLog(self, "Hello")
        validateLogLine(0, methodName: "testBaseLogging", lineNumber: #line - 1, message: "Hello")
    }

    // MARK:- Internal

    func validateLogLine(_ atIndex:Int, methodName:String, lineNumber:Int, message:String) {
        let fullFilename:NSString = #file
        let filename = fullFilename.lastPathComponent
        let expected = "\(filename):\(lineNumber) \(message)"
        let loggedMsg = _inMemoryLogger.log[atIndex]
        let idx = loggedMsg.index(loggedMsg.startIndex, offsetBy: 13)
        XCTAssertEqual(expected, loggedMsg.substring(from:idx))
    }
}
