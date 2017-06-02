//
//  PokemonsView.swift
//  Pokedex
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import NibDesignable

final class PokemonsView: NibDesignable {

    @IBOutlet weak var pokemonsListCollectionView: UICollectionView!

    var viewModel: PokemonsViewModel! {
        didSet {
            viewModel.initialize(with: pokemonsListCollectionView)
        }
    }

}
