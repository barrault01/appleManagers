//
//  ManagerAPI.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation

public struct ManagerAPI {

    public init() {}
    public func fetchManagers(_ completion: ([ManagerProtocol]) -> Void) {
        let parser = ManagerParser()
        let managers = parser.parseManagers(with: "managers")
        completion(managers)
    }
}
