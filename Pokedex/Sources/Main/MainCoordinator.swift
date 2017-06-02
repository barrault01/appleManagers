//
//  MainCoordinator.swift
//  Pokedex
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import PokedexAPI

class MainCoordinator: Coordinator {

    fileprivate unowned let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showPokemons()
    }

}

extension MainCoordinator {

    func showPokemons() {

        let api = API()
        let pokemonDataSource = Pokemon.fetchResultsControllerForOrdered()
        let arquiver = CoreDataArquiver()
        arquiver.context = CoreDataStack.shared.managedObjectContext
        let rootCoordinator = PokemonCoordinator(window: self.window,
                                                 api: api,
                                                 pokemonDataSource:pokemonDataSource,
                                                 pokemonArquiver: arquiver)
        rootCoordinator.start()

    }
}
