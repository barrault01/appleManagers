//
//  MainCoordinatorTests.swift
//  AppleManagersTests
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest
@testable import AppleManagers

class MainCoordinatorTests: XCTestCase {

    func testThatMainCoordinatorPresentManagerCoordinator() {

        //given
        let window = UIWindow()
        let mainCoordinator = MainCoordinator(window: window)
        //when
        mainCoordinator.start()
        //then
        guard let rootViewController = window.rootViewController else {
            XCTFail("the rootviewController need to be setted")
            return
        }

        let isManagersViewControllerClass = rootViewController.isKind(of: ManagersViewController.self)
        XCTAssert(isManagersViewControllerClass)

    }
}
