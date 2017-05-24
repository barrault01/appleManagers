//
//  Registrable.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit

protocol Registrable {
    static func registerIn(collectionView view: UICollectionView)
    static func cellIdentifier() -> String
}

extension Registrable where Self: UICollectionViewCell {

    static func registerIn(collectionView view: UICollectionView) {
        let identifier = cellIdentifier()
        if let nib = nibForSelf() {
            view.register(nib, forCellWithReuseIdentifier: identifier)
        } else {
            view.register(self, forCellWithReuseIdentifier: identifier)
        }
    }

    static func cellIdentifier() -> String {
        return classShortName(self)
    }

}
