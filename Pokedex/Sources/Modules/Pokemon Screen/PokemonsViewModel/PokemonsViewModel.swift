//
//  PokemonsViewModel.swift
//  Pokedex
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import CoreData
import PokedexAPI

final class PokemonsViewModel: NSObject {

    var pokemonsFetchController: FiltrableCollectionDataSource
    init(pokemonsFetchController: FiltrableCollectionDataSource) {
        self.pokemonsFetchController = pokemonsFetchController
    }

    func initialize(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        registerCells(in: collectionView)
        self.pokemonsFetchController.collectionView = collectionView
        do {
            try self.pokemonsFetchController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func registerCells(in collectionView: UICollectionView) {
        PokemonCollectionViewCell.registerIn(collectionView: collectionView)
    }
}
