//
//  ManagersView.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import NibDesignable

final class ManagersView: NibDesignable {

    @IBOutlet weak var managersListCollectionView: UICollectionView!

    var viewModel: ManagersViewModel! {
        didSet {
            viewModel.initialize(with: managersListCollectionView)
        }
    }

}
