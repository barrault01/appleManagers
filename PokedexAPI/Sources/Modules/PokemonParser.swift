//
//  PokemonParser.swift
//  Pokedex
//
//  Created by Antoine Barrault on 01/06/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation

struct PokemonParser {

    func parsePokemons(with filename: String) -> [PokemonProtocol] {
        var pokemons = [String: PokemonProtocol]()
        let parser = JsonParser()
        guard let json = parser.jsonSerialized(with: filename) as? [[String: Any]]  else {
            return Array(pokemons.values)
        }
        for pokemon in json {
            let parsedPokemon = self.parsePokemon(using: pokemon)
            pokemons["\(parsedPokemon.pokemonId)"] = parsedPokemon

        }

        return Array(pokemons.values).sorted {return $0.0.pokemonId < $0.1.pokemonId}
    }

    private func parsePokemon(using pokemonRepresentation: [String: Any]) -> PokemonProtocol {

        // swiftlint:disable:next force_cast
        let pokemonId = pokemonRepresentation["id"] as! Int
        let name = pokemonRepresentation["name"] as? String
        let types = pokemonRepresentation["type"] as? [String]
        let img = pokemonRepresentation["img"] as? String
        let num = pokemonRepresentation["num"] as? String
        let weight = pokemonRepresentation["weight"] as? String
        let height = pokemonRepresentation["height"] as? String

        let pokemon = Pokemon(pokemonId: pokemonId,
                              type: types,
                              img: img,
                              name: name,
                              num: num,
                              weight: weight,
                              height: height)

        return pokemon
    }

}

fileprivate struct Pokemon: PokemonProtocol {

    var pokemonId: Int
    var type: [String]?
    var img: String?
    var name: String?
    var num: String?
    var weight: String?
    var height: String?
}
