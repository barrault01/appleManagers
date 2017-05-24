//
//  ManagersViewModel+CollectionView.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import ManagersAPI

extension ManagersViewModel: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = ManagerCollectionViewCell.cellIdentifier()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let cell = cell as? ManagerCollectionViewCell,
            let object = managersFetchController.object(at: indexPath) as? ManagerProtocol {
            cell.configure(with: object)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return managersFetchController.numberOfobjects(for: section)
    }

}

extension ManagersViewModel: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.size.width / CGFloat(numberOfManagerInRow(for: collectionView))
        return CGSize(width: width, height: width)

    }

    func numberOfManagerInRow(for interfaceIdiom: UIUserInterfaceSizeClass,
                              and orientation: UIDeviceOrientation) -> Int {

        var numberOfRow = 1

        if interfaceIdiom == .regular {
            numberOfRow += 1
        }

        if orientation.isLandscape {
            numberOfRow += 1
        }
        return numberOfRow

    }

    private func numberOfManagerInRow(for collectionView: UICollectionView) -> Int {

        let sizeClass = collectionView.traitCollection.horizontalSizeClass
        let orientation = UIDevice.current.orientation

        return numberOfManagerInRow(for: sizeClass,
                                    and: orientation)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {

        return CGSize(width: 0, height: 0)
    }
}
