//
//  JsonParserTests.swift
//  PokedexAPITests
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest
@testable import PokedexAPI

fileprivate let fileThatExisted = "pokedex"
fileprivate let fileThatNotExisted = "unknow"

class JsonParserTests: XCTestCase {

    func testBundleLoading() {
        let value = JsonParser.bundle
        XCTAssertNotNil(value)
    }

    func testPathForFileInBundle() {
        let value = JsonParser().pathForJsonFile(with: fileThatExisted)
        XCTAssertNotNil(value)
    }

    func testPathForFileInBundleFileWithFileThatNotExisted() {
        let value = JsonParser().pathForJsonFile(with: fileThatNotExisted)
        XCTAssertNil(value)
    }

    func testUrlForFileInBundle() {
        let value = JsonParser().urlForPathOfJsonFile(with: fileThatExisted)
        XCTAssertNotNil(value)
    }

    func testUrlForFileInBundleFileWithFileThatNotExisted() {
        let value = JsonParser().urlForPathOfJsonFile(with: fileThatNotExisted)
        XCTAssertNil(value)
    }

    func testDataFromJSONFile () {
        let value = JsonParser().dataFromFile(with: fileThatExisted)
        XCTAssertNotNil(value)
    }

    func testDataFromJSONFileWithFileThatNotExisted() {
        let value = JsonParser().dataFromFile(with: fileThatNotExisted)
        XCTAssertNil(value)
    }

    func testThatValideFileIsCorrect() {
        let jsonResult = JsonParser().jsonSerialized(with: fileThatExisted)
        XCTAssertNotNil(jsonResult)
    }

    func testThatUnknowFileReturnNilIsCorrect() {
        let jsonResult = JsonParser().jsonSerialized(with: fileThatNotExisted)
        XCTAssertNil(jsonResult)
    }
}
