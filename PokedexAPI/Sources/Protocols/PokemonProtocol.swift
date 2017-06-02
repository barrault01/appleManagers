//
//  PokemonProtocol.swift
//  Pokedex
//
//  Created by Antoine Barrault on 01/06/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation

public protocol PokemonProtocol {

    var pokemonId: Int { get set }
    var type: [String]? { get set }
    var img: String? { get set }
    var name: String? { get set }
    var num: String? { get set }
    var weight: String? { get set }
    var height: String? { get set }
}

public protocol PokemonArquiver {
    func receivedPokemons(pokemons: [PokemonProtocol])
}
