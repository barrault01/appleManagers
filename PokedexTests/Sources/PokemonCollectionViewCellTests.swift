//
//  PokemonCollectionViewCellTests.swift
//  Pokedex
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import XCTest

@testable import Alamofire
@testable import AlamofireImage
@testable import Pokedex
@testable import PokedexAPI

import OHHTTPStubs

fileprivate struct MockPokemon: PokemonProtocol {
    var pokemonId: Int = 1
    var type: [String]? = ["Grass", "Poison"]
    var img: String? = "http://somefakeimage.com"
    var name: String? = "Bulbasaur"
    var num: String? = "001"
    var weight: String? = "6.9 kg"
    var height: String? = "0.71 m"
}

fileprivate struct MockDownloadImagePokemon: DownloadingImage {

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

class PokemonCollectionViewCellTests: XCTestCase {

    fileprivate var cell: PokemonCollectionViewCell?

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: PokemonCollectionViewCell.self)
        let nib = bundle.loadNibNamed("PokemonCollectionViewCell", owner: nil, options: nil)
        cell = nib?.first as? PokemonCollectionViewCell
    }

    override func tearDown() {
        cell = nil
        OHHTTPStubs.removeAllStubs()
        UIImageView.af_sharedImageDownloader.imageCache?.removeAllImages()
        super.tearDown()
    }

    func testLoadingCat() {
        let testBundle = Bundle(for: PokemonCollectionViewCellTests.self)
        guard let path = testBundle.path(forResource: "cat", ofType: "jpeg") else {
            XCTFail("cat file not found")
            return

        }
        let data = NSData(contentsOfFile: path)
        XCTAssertNotNil(data)

    }

    func testThatIsApplyingPokemonCorrectly() {

        let testBundle = Bundle(for: PokemonCollectionViewCellTests.self)

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
        var imageDownloader = MockDownloadImagePokemon(imageView: cell.pokemonImageView)
        let exp = expectation(description: "wait finish to downlaod picture")
        imageDownloader.downloadCompletion = { _ in
            exp.fulfill()
        }

        cell.configure(with: MockPokemon(), imageDownloader: imageDownloader)

        waitForExpectations(timeout: 2)
        guard let imageFromImageView = cell.pokemonImageView.image else {
            XCTFail("image should be setted on pokemonImageView after download")
            return
        }

        //then

        let imageFromImageViewInJPEG = UIImageJPEGRepresentation(imageFromImageView, 1.0)
        let imageToCompareInJPEG = UIImageJPEGRepresentation(referenceImage, 1.0)
        XCTAssert(imageFromImageViewInJPEG == imageToCompareInJPEG)
        XCTAssert(cell.pokemonNameLabel.text == "Bulbasaur")
        XCTAssert(cell.pokemonBirthdayLabel.text == "001")

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
        var imageDownloader = MockDownloadImagePokemon(imageView: cell.pokemonImageView)
        let exp = expectation(description: "hello")
        imageDownloader.downloadCompletion = { _ in
            exp.fulfill()
        }

        cell.configure(with: MockPokemon(), imageDownloader: imageDownloader)

        //then
        XCTAssert(cell.pokemonNameLabel.text == "Bulbasaur")
        XCTAssert(cell.pokemonBirthdayLabel.text == "001")
        waitForExpectations(timeout: 2)
        XCTAssert(cell.pokemonImageView.image == #imageLiteral(resourceName: "error"))

    }

    func testThatCellClearOldImageOnApplyingPokemon() {

        //given
        guard let cell = self.cell else {
            XCTFail("cell was not initialized")
            return
        }
        let image = UIImage()
        cell.pokemonImageView.image = image
        XCTAssert(cell.pokemonImageView.image == image)
        var mockPokemon = MockPokemon()
        mockPokemon.img = nil

        //when
        cell.configure(with: mockPokemon)

        //then
        XCTAssert(cell.pokemonImageView.image == nil)

    }

}
