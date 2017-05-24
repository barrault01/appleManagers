//
//  ManagerCoordinatorTests.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 01/06/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest
@testable import AppleManagers
@testable import ManagersAPI

class ManagerCoordinatorTests: XCTestCase {

    func testThatMainCoordinatorPresentManagerCoordinator() {

        //given
        let window = UIApplication.shared.keyWindow!
        let api = ManagerAPI()
        let mockedDataSource = MockManagersDataSource()
        let mockedArquiver = MockArquiver()
        let mainCoordinator = ManagerCoordinator(window: window,
                                                 api: api,
                                                 managerDataSource: mockedDataSource,
                                                 managerArquiver: mockedArquiver)
        //when
        mainCoordinator.start()
        guard let rootViewController = window.rootViewController as? ManagersViewController else {
            XCTFail("the rootviewController is not a ManagersViewController")
            return
        }
        try? mockedDataSource.performFetch()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))

        //then

        let items = rootViewController.theView.managersListCollectionView.numberOfItems(inSection: 0)
        XCTAssert(items == 4, "it should be 4 items today it's \(items)")
        let cell = rootViewController.theView.managersListCollectionView.visibleCells.first
        guard let item = cell as? ManagerCollectionViewCell else {
            XCTFail("the cell is not a ManagerCollectionViewCell")
            return
        }
        XCTAssert(item.managerNameLabel.text == "Sundar Pichai")
    }

}

fileprivate struct MockArquiver: ManagerArquiver {

    func receivedManagers(managers: [ManagerProtocol]) {

    }
}

fileprivate struct MockManagersDataSource: CollectionDataSource {

    func object(at indexPath: IndexPath) -> Any? {
        return MockManager()
    }

    func numberOfobjects(for sectionIndex: Int) -> Int {
        return 4
    }

    func performFetch() throws {
        collectionView?.reloadData()
    }

    var collectionView: UICollectionView?

}

fileprivate struct MockManager: ManagerProtocol {
    var managerId: String? = "97d16abc-1569-43e0-929b-cef05cd850fb"
    var name: String? = "Sundar Pichai"
    var birthday: Date? = {
        var components = DateComponents()
        components.day = 25
        components.month = 5
        components.year = 2017
        components.calendar = NSCalendar.current
        return components.date
    }()
    var pictureUrl: String? = "http://somefakeimage.com/id.jpeg"
}
