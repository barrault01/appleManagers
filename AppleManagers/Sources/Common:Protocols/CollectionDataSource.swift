//
//  CollectionDataSource.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 26/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit

protocol CollectionDataSource {
    func object(at indexPath: IndexPath) -> Any?
    func numberOfobjects(for sectionIndex: Int) -> Int
    var collectionView: UICollectionView? { get set}
    func performFetch() throws
}
