//
//  CoreDataArquiver.swift
//  Pokedex
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation
import CoreData
import PokedexAPI

final class CoreDataArquiver {

    var context: NSManagedObjectContext!

    fileprivate func saveMainContext() {
        self.context.perform {
            do {
                try self.context.save()
            } catch {
                print("error saving main context: \(error)")
            }
        }
    }
}

extension CoreDataArquiver: PokemonArquiver {

    func receivedPokemons(pokemons: [PokemonProtocol]) {
        self.save(pokemons: pokemons)
    }

    private func save(pokemons: [PokemonProtocol]) {

        let temporaryContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        temporaryContext.parent = self.context
        temporaryContext.perform {
            for pokemon in pokemons {
                _ = Pokemon.create(pokemon, in: temporaryContext)
            }
            do {
                try temporaryContext.save()
                self.saveMainContext()
            } catch let error as NSError {
                print("Could not save Pokemon. Error = \(error)")
            }
        }
    }
}
