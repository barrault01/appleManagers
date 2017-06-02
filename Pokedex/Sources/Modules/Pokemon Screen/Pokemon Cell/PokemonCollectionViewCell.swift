//
//  PokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import PokedexAPI

final class PokemonCollectionViewCell: UICollectionViewCell, Registrable {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonBirthdayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor(red:228/255.0, green:228/255.0, blue:228/255.0, alpha:0.75).cgColor
    }

    func configure(with pokemon: PokemonProtocol, imageDownloader: DownloadingImage? = nil) {
        self.pokemonImageView.image = nil
        self.pokemonNameLabel.text = pokemon.name
        self.pokemonBirthdayLabel.text =  pokemon.num
        guard let imageDownloader = imageDownloader else {
            self.downloadImageIfNeed(urlInString: pokemon.img)
            return
        }
        imageDownloader.downloadImageIfNeed(urlInString: pokemon.img)
    }
}

extension PokemonCollectionViewCell: DownloadingImage {

    func imageViewToApplyImage() -> UIImageView {
        return self.pokemonImageView
    }
}
