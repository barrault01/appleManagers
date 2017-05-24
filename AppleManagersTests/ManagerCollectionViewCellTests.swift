//
//  ManagerCollectionViewCellTests.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest

@testable import Alamofire
@testable import AlamofireImage
@testable import OHHTTPStubs
@testable import AppleManagers
@testable import ManagersAPI

fileprivate struct MockManager: ManagerProtocol {
    var managerId: String? = "97d16abc-1569-43e0-929b-cef05cd850fb"
    var name: String? = "Steve Jobs"
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

fileprivate struct MockDownloadImageManager: DownloadingImage {

    var imageView: UIImageView
    var downloadCompletion: ((Bool) -> Void)?

    init(imageView: UIImageView) {
        self.imageView = imageView
    }
    func imageViewToApplyImage() -> UIImageView {
        return self.imageView
    }

    func downloadCompletionBlock() -> ((Bool) -> Void)? {
        return self.downloadCompletion
    }
}

class ManagerCollectionViewCellTests: XCTestCase {

    fileprivate var cell: ManagerCollectionViewCell?

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: ManagerCollectionViewCell.self)
        let nib = bundle.loadNibNamed("ManagerCollectionViewCell", owner: nil, options: nil)
        cell = nib?.first as? ManagerCollectionViewCell
    }

    override func tearDown() {
        cell = nil
        OHHTTPStubs.removeAllStubs()
        UIImageView.af_sharedImageDownloader.imageCache?.removeAllImages()
        super.tearDown()
    }

    func testLoadingCat() {
        let testBundle = Bundle(for: ManagerCollectionViewCellTests.self)
        guard let path = testBundle.path(forResource: "cat", ofType: "jpeg") else {
            XCTFail("cat file not found")
            return

        }
        let data = NSData(contentsOfFile: path)
        XCTAssertNotNil(data)

    }

    func testThatIsApplyingManagerCorrectly() {

        let testBundle = Bundle(for: ManagerCollectionViewCellTests.self)

        //given
        guard let cell = self.cell else {
            XCTFail("cell was not initialized")
            return
        }
        guard let path = testBundle.path(forResource: "cat", ofType: "jpeg") else {
            XCTFail("can't found local file in test bundle : cat.jpeg")
            return
        }
        stub(condition: isHost("somefakeimage.com")) { _ in
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type": "image/jpeg"])
        }

        let url = URL(fileURLWithPath: path)

        guard let data = try? Data.init(contentsOf: url, options: .uncached),
            let referenceImage = UIImage.af_threadSafeImage(with: data, scale: UIScreen.main.scale) else {
                XCTFail("image reference should exists")
                return
        }

        //when

        XCTAssert(OHHTTPStubs.allStubs().count == 1)

        var imageDownloader = MockDownloadImageManager(imageView: cell.managerImageView)
        let exp = expectation(description: "wait finish to downlaod picture")
        imageDownloader.downloadCompletion = { _ in
            exp.fulfill()
        }

        cell.configure(with: MockManager(), imageDownloader: imageDownloader)

        waitForExpectations(timeout: 2)
        guard let imageFromImageView = cell.managerImageView.image else {
            XCTFail("image should be setted on managerImageView after download")
            return
        }

        //then

        let imageFromImageViewInJPEG = UIImageJPEGRepresentation(imageFromImageView, 1.0)
        let imageToCompareInJPEG = UIImageJPEGRepresentation(referenceImage, 1.0)
        XCTAssert(imageFromImageViewInJPEG == imageToCompareInJPEG)
        XCTAssert(cell.managerNameLabel.text == "Steve Jobs")
        XCTAssert(cell.managerBirthdayLabel.text == "🎂  25 May 2017  🎂")

    }

    func testThatIsShowPlaceholderForImageIfDownlaodFailed() {

        //given
        guard let cell = self.cell else {
            XCTFail("cell was not initialized")
            return
        }
        //when
        stub(condition: isHost("somefakeimage.com")) { _ in
            return OHHTTPStubsResponse(data:Data(), statusCode: 400, headers: nil)
        }
        XCTAssert(OHHTTPStubs.allStubs().count == 1)
        var imageDownloader = MockDownloadImageManager(imageView: cell.managerImageView)
        let exp = expectation(description: "hello")
        imageDownloader.downloadCompletion = { _ in
            exp.fulfill()
        }

        cell.configure(with: MockManager(), imageDownloader: imageDownloader)

        //then
        XCTAssert(cell.managerNameLabel.text == "Steve Jobs")
        XCTAssert(cell.managerBirthdayLabel.text == "🎂  25 May 2017  🎂")
        waitForExpectations(timeout: 2)
        XCTAssert(cell.managerImageView.image == #imageLiteral(resourceName: "error"))

    }

    func testThatCellClearOldImageOnApplyingManager() {

        //given
        guard let cell = self.cell else {
            XCTFail("cell was not initialized")
            return
        }
        let image = UIImage()
        cell.managerImageView.image = image
        XCTAssert(cell.managerImageView.image == image)
        var mockManager = MockManager()
        mockManager.pictureUrl = nil

        //when
        cell.configure(with: mockManager)

        //then
        XCTAssert(cell.managerImageView.image == nil)

    }

    func testBirthdayStringFormatter() {

        //given
        var components = DateComponents()
        components.day = 25
        components.month = 5
        components.year = 2017
        components.calendar = NSCalendar.current

        let date = components.date
        //when
        let string = cell?.birthdayStringForLabel(with: date)
        //then
        XCTAssert(string == "🎂  25 May 2017  🎂")

    }

    func testBirthdayStringFormatterWithNoDate() {

        //given
        //when
        let string = cell?.birthdayStringForLabel(with: nil)
        //then
        XCTAssert(string == "🎂: not informed")

    }

}
