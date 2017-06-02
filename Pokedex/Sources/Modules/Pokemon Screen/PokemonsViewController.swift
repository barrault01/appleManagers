//
//  PokemonsViewController.swift
//  Pokedex
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import OHHTTPStubs

final class PokemonsViewController: UIViewController {

    @IBOutlet var theView: PokemonsView!
    var viewModel: PokemonsViewModel?
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = createSearchController()
        if #available(iOS 11, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.searchController = self.searchController
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        self.navigationController?.title = "Pokemons"
        for pokenmonNumber in 1...151 {
            stub(condition: isHost("fakeurl.local") && isPath("/images/\(pokenmonNumber).png")) { _ in
                if let path = OHPathForFile("\(pokenmonNumber).png", type(of: self)) {
                    return fixture(filePath: path, headers: ["Content-Type": "image/png"])
                }
                return OHHTTPStubsResponse()
            }
        }
        theView.viewModel = viewModel
    }

    private func createSearchController() -> UISearchController {
        let searchCtrl = UISearchController(searchResultsController: nil)
        searchCtrl.searchResultsUpdater = viewModel
        searchCtrl.delegate = viewModel
        searchCtrl.dimsBackgroundDuringPresentation = false
        return searchCtrl
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.theView.pokemonsListCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }

}
