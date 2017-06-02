//
//  PokemonsViewModel+UISearchResultsUpdating.swift
//  Alamofire
//
//  Created by Antoine Barrault on 08/06/2017.
//

import UIKit

extension PokemonsViewModel: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.characters.count > 0  else {
            self.searchForPokemon(named: "")
            return
        }
        self.searchForPokemon(named: text)
    }

    func searchForPokemon(named: String) {
        self.pokemonsFetchController.filter(with: named, for: "name")
    }

}

extension PokemonsViewModel: UISearchControllerDelegate {

    func didDismissSearchController(_ searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print("didDismissSearchController with value: \(text)")
    }
}
