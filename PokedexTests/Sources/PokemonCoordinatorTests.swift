//
//  PokemonCoordinatorTests.swift
//  Pokedex
//
//  Created by Antoine Barrault on 01/06/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest
@testable import Pokedex
@testable import PokedexAPI

class PokemonCoordinatorTests: XCTestCase {

    func testThatMainCoordinatorPresentPokemonCoordinator() {

        //given
        let window = UIApplication.shared.keyWindow!
        let api = API()
        let mockedDataSource = MockPokemonsDataSource()
        let mockedArquiver = MockArquiver()
        let mainCoordinator = PokemonCoordinator(window: window,
                                                 api: api,
                                                 pokemonDataSource: mockedDataSource,
                                                 pokemonArquiver: mockedArquiver)
        //when
        mainCoordinator.start()
        guard let rootViewController =
            window.rootViewController?.childViewControllers.first as? PokemonsViewController else {
            XCTFail("the rootviewController is not a PokemonsViewController")
            return
        }
        try? mockedDataSource.performFetch()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))

        //then

        let items = rootViewController.theView.pokemonsListCollectionView.numberOfItems(inSection: 0)
        XCTAssert(items == 4, "it should be 4 items today it's \(items)")
        let cell = rootViewController.theView.pokemonsListCollectionView.visibleCells.first
        guard let item = cell as? PokemonCollectionViewCell else {
            XCTFail("the cell is not a PokemonCollectionViewCell")
            return
        }
        XCTAssert(item.pokemonNameLabel.text == "Bulbasaur")
    }

}

fileprivate struct MockArquiver: PokemonArquiver {

    func receivedPokemons(pokemons: [PokemonProtocol]) {

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
