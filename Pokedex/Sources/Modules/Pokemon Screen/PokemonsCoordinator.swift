//
//  PokemonCoordinator.swift
//  Pokedex
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import PokedexAPI

final class PokemonCoordinator: Coordinator {

    fileprivate unowned let window: UIWindow

    var currentViewController: UIViewController?
    var api: API
    var pokemonDataSource: FiltrableCollectionDataSource
    var pokemonArquiver: PokemonArquiver

    init(window: UIWindow,
         api: API,
         pokemonDataSource: FiltrableCollectionDataSource,
         pokemonArquiver: PokemonArquiver) {
        self.window = window
        self.api = api
        self.pokemonDataSource = pokemonDataSource
        self.pokemonArquiver = pokemonArquiver
    }

    func start() {

        api.fetchPokemons { [unowned self] pokemons in
            self.pokemonArquiver.receivedPokemons(pokemons: pokemons)
        }
        let storyboard = UIStoryboard(name: "Pokemons", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController(),
            let pokemons = vc.childViewControllers.first as? PokemonsViewController {
            let viewModel = PokemonsViewModel(pokemonsFetchController: pokemonDataSource)
            pokemons.viewModel = viewModel
            self.currentViewController = pokemons
            window.rootViewController = vc
        }
    }

}
