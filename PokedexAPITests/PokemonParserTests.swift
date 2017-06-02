//
//  PokemonParserTests.swift
//  Pokedex
//
//  Created by Antoine Barrault on 01/06/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest
@testable import PokedexAPI

class PokemonParserTests: XCTestCase {

    func testParsingJsonOfPokemons () {

        //given
        let api = API()
        let fetchPokemonsExpetation = expectation(description: "Fetch Pokemons")

        //when

        api.fetchPokemons { (pokemons) in

            let pokemonsCount = pokemons.count
            //then
            XCTAssert(pokemonsCount == 151, "number total of pokemons should be 151")
            guard let bulbizar = pokemons.first else {
                XCTFail("bulbizar not found")
                return
            }
            XCTAssert(bulbizar.pokemonId == 1 )
            XCTAssert(bulbizar.type! == ["Grass", "Poison"])
            XCTAssert(bulbizar.img == "http://fakeurl.local/images/1.png")
            XCTAssert(bulbizar.name == "Bulbasaur")
            XCTAssert(bulbizar.num == "001")
            XCTAssert(bulbizar.weight == "6.9 kg")
            XCTAssert(bulbizar.height == "0.71 m")

            fetchPokemonsExpetation.fulfill()
        }

        waitForExpectations(timeout: 2.0)
    }

}
