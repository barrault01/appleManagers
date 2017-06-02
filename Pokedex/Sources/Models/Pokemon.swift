//
//  Pokemon.swift
//  Pokedex
//
//  Created by Antoine Barrault on 01/06/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation
import CoreData
import PokedexAPI

final class Pokemon: NSManagedObject, PokemonProtocol {

    var pokemonId: Int {
        get {
            return Int(pokemonIdCD)
        }

        set {
            pokemonIdCD = Int16(newValue)
        }
    }
    @NSManaged public var pokemonIdCD: Int16
    @NSManaged public var type: [String]?
    @NSManaged public var img: String?
    @NSManaged public var name: String?
    @NSManaged public var num: String?
    @NSManaged public var weight: String?
    @NSManaged public var height: String?

    static func create(_ pokemon: PokemonProtocol, in context: NSManagedObjectContext) -> Pokemon? {

        var object: Pokemon?
        let request = uniqueManageFetchRequest(pokemonId: pokemon.pokemonId, in: context)
        if let pokemons = try? context.fetch(request), let obj = pokemons.first {
            object = obj
        } else {
            object = createPokemon(in: context)
        }
        object?.configure(using: pokemon)
        return object
    }

    static func fetchResultsControllerForOrdered() -> CollectionViewFetchedResultsController<Pokemon> {

        let request = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        let sort = NSSortDescriptor(key: "num", ascending: true)
        request.sortDescriptors = [sort]
        let context = CoreDataStack.shared.managedObjectContext
        let pokemons =
            CollectionViewFetchedResultsController<Pokemon>(request: request,
                                                            managedObjectContext: context!)
        return pokemons
    }

}

fileprivate extension Pokemon {

    static func uniqueManageFetchRequest(pokemonId: Int,
                                         in context: NSManagedObjectContext) -> NSFetchRequest<Pokemon> {
        let predicate = NSPredicate(format: "pokemonIdCD = %i", pokemonId)
        let request = fetchRequest(in: context)
        request.predicate = predicate
        request.fetchLimit = 1
        return request
    }

    static func fetchRequest(in context: NSManagedObjectContext) -> NSFetchRequest<Pokemon> {
        let entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: context)
        let request = NSFetchRequest<Pokemon>()
        request.entity = entity
        return request
    }

    static func createPokemon(in context: NSManagedObjectContext) -> Pokemon? {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: "Pokemon", into: context) as? Pokemon else {
            assertionFailure("we could not create a Pokemon something goes wrong")
            return nil
        }
        return obj
    }

    func configure(using pokemon: PokemonProtocol) {

       pokemonId = pokemon.pokemonId
       type = pokemon.type
       img = pokemon.img
       name = pokemon.name
       num = pokemon.num
       weight = pokemon.weight
       height = pokemon.height

    }
}
