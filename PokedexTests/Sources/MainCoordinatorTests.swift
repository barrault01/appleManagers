//
//  MainCoordinatorTests.swift
//  PokedexTests
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest
@testable import Pokedex

class MainCoordinatorTests: XCTestCase {

    func testThatMainCoordinatorPresentPokemonCoordinator() {

        //given
        let window = UIWindow()
        let mainCoordinator = MainCoordinator(window: window)
        //when
        mainCoordinator.start()
        //then
        guard let rootViewController = window.rootViewController?.childViewControllers.first else {
            XCTFail("the rootviewController need to be setted")
            return
        }

        let isPokemonsViewControllerClass = rootViewController.isKind(of: PokemonsViewController.self)
        XCTAssert(isPokemonsViewControllerClass)

    }
}
