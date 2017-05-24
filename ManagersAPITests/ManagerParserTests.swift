//
//  ManagerParserTests.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest
@testable import ManagersAPI

class ManagerParserTests: XCTestCase {

    func testParsingJsonOfManagers () {

        //given
        let api = ManagerAPI()
        let fetchManagersExpetation = expectation(description: "Fetch Managers")

        //when

        api.fetchManagers { (managers) in

            let managersCount = managers.count
            //then
            XCTAssert(managersCount == 6, "number total of managers should be 6 because we have one duplicate")
            guard let firstManager = managers.first else {
                XCTFail("First Manager not found")
                return
            }
            XCTAssert(firstManager.name == "Steve Jobs")
            XCTAssert(firstManager.managerId == "97d16abc-1569-43e0-929b-cef05cd850fb")
            XCTAssert(firstManager.pictureUrl == "http://adsoftheworld.com/files/steve-jobs.jpg")

            XCTAssert(firstManager.birthday == "1955-02-24T00:00:00Z".dateInISO8601())
            fetchManagersExpetation.fulfill()
        }

        waitForExpectations(timeout: 2.0)
    }

    func testParsingWithUnknowFile() {

        //given
        let parser =  ManagerParser()

        //when
        let managers = parser.parseManagers(with: "some")
        let managersCount = managers.count
        //then

        XCTAssert(managersCount == 0, "it should return 0 managers has the file not exists")
    }

}
