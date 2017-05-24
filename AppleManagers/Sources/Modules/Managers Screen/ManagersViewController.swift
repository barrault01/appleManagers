//
//  ManagersViewController.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit

final class ManagersViewController: UIViewController {

    @IBOutlet var theView: ManagersView!
    var viewModel: ManagersViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        theView.viewModel = viewModel
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
                self.theView.managersListCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }

}
