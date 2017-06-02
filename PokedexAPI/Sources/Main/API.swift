//
//  API.swift
//  Pokedex
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation

public struct API {

    public init() {}
    public func fetchPokemons(_ completion: ([PokemonProtocol]) -> Void) {
        let parser = PokemonParser()
        let pokemons = parser.parsePokemons(with: "pokedex")
        completion(pokemons)
    }

}
