//
//  ManagersViewModelTests.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 01/06/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest
@testable import AppleManagers
@testable import ManagersAPI

class ManagersViewModelTests: XCTestCase {

    fileprivate var model: ManagersViewModel?

    override func setUp() {
        super.setUp()
        model = ManagersViewModel(managersFetchController: MockManagersDataSource())
    }

    override func tearDown() {
        model = nil
        super.tearDown()
    }

    func testNumberOfManagerInRow () {

        //given
        //when
        let rowForPad = model?.numberOfManagerInRow(for: .regular,
                                                    and: .portrait)
        let rowForPadLandscape = model?.numberOfManagerInRow(for: .regular,
                                                             and: .landscapeLeft)
        let rowForPhone = model?.numberOfManagerInRow(for: .compact,
                                                      and: .portrait)
        let rowForPhoneLandscape = model?.numberOfManagerInRow(for: .compact,
                                                               and: .landscapeLeft)
        //then
        XCTAssert(rowForPhone == 1)
        XCTAssert(rowForPhoneLandscape == 2)
        XCTAssert(rowForPad == 2)
        XCTAssert(rowForPadLandscape == 3)
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
