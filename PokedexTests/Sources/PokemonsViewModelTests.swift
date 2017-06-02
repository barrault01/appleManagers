//
//  PokemonsViewModelTests.swift
//  Pokedex
//
//  Created by Antoine Barrault on 01/06/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest
@testable import Pokedex
@testable import PokedexAPI

class PokemonsViewModelTests: XCTestCase {

    fileprivate var model: PokemonsViewModel?

    override func setUp() {
        super.setUp()
        model = PokemonsViewModel(pokemonsFetchController: MockPokemonsDataSource())
    }

    override func tearDown() {
        model = nil
        super.tearDown()
    }

    func testNumberOfPokemonInRow () {

        //given
        //when
        let rowForPad = model?.numberOfPokemonInRow(for: .regular,
                                                    and: .portrait)
        let rowForPadLandscape = model?.numberOfPokemonInRow(for: .regular,
                                                             and: .landscapeLeft)
        let rowForPhone = model?.numberOfPokemonInRow(for: .compact,
                                                      and: .portrait)
        let rowForPhoneLandscape = model?.numberOfPokemonInRow(for: .compact,
                                                               and: .landscapeLeft)
        //then
        XCTAssert(rowForPhone == 1)
        XCTAssert(rowForPhoneLandscape == 2)
        XCTAssert(rowForPad == 2)
        XCTAssert(rowForPadLandscape == 3)
    }

}

fileprivate struct MockPokemonsDataSource: FiltrableCollectionDataSource {

    func filter(with string: String, for parameter: String) {

    }

    func object(at indexPath: IndexPath) -> Any? {
        return MockPokemon()
    }

    func numberOfobjects(for sectionIndex: Int) -> Int {
        return 4
    }

    func performFetch() throws {
        collectionView?.reloadData()
    }

    var collectionView: UICollectionView?
}

fileprivate struct MockPokemon: PokemonProtocol {
    var pokemonId: Int = 1
    var type: [String]? = ["Grass", "Poison"]
    var img: String? = ""
    var name: String? = "Bulbasaur"
    var num: String? = "001"
    var weight: String? = "6.9 kg"
    var height: String? = "0.71 m"
}
