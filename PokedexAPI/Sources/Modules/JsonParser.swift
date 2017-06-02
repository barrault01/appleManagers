//
//  JsonParser.swift
//  Pokedex
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation

class JsonParser {

    static let bundle: Bundle = {
        let bundle = Bundle(for: JsonParser.self)
        return bundle
    }()

    func pathForJsonFile(with name: String) -> String? {
        let bundle = JsonParser.bundle
        guard let path = bundle.path(forResource: name, ofType: "json") else {
            return nil
        }
        return path
    }

    func urlForPathOfJsonFile(with name: String) -> URL? {
        if let path = pathForJsonFile(with: name) {
            return URL(fileURLWithPath: path)
        }
        return nil
    }

    func dataFromFile(with name: String) -> Data? {
        if let url = urlForPathOfJsonFile(with: name) {
            let jsonData = try? Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
            return jsonData
        }
        return nil
    }

    func jsonSerialized(with name: String) -> [Any]? {
        guard let value = dataFromFile(with: name) else {
            return nil
        }
        let jsonResult = try? JSONSerialization.jsonObject(with: value, options: .allowFragments)

        return jsonResult as? [Any]
    }
}
