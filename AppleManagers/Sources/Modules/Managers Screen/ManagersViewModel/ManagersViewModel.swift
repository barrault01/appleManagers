//
//  ManagersViewModel.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import CoreData
import ManagersAPI

final class ManagersViewModel: NSObject {

    var managersFetchController: CollectionDataSource
    init(managersFetchController: CollectionDataSource) {
        self.managersFetchController = managersFetchController
    }

    func initialize(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        registerCells(in: collectionView)
        self.managersFetchController.collectionView = collectionView
        do {
            try self.managersFetchController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func registerCells(in collectionView: UICollectionView) {
        ManagerCollectionViewCell.registerIn(collectionView: collectionView)
    }

}
