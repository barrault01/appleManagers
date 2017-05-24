//
//  ManagerParser.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation

struct ManagerParser {

    func parseManagers(with filename: String) -> [ManagerProtocol] {
        var managers = [String: ManagerProtocol]()
        let parser = JsonParser()
        guard let json = parser.jsonSerialized(with: filename) as? [[String: Any]]  else {
            return Array(managers.values)
        }
        for manager in json {
            let parsedManager = self.parseManager(using: manager)
            if let managerID = parsedManager.managerId {
                managers[managerID] = parsedManager
            }
        }

        return Array(managers.values)
    }

    private func parseManager(using managerRepresentation: [String: Any]) -> ManagerProtocol {

        let managerId = managerRepresentation["id"] as? String
        let name = managerRepresentation["name"] as? String
        let birthday = (managerRepresentation["birthday"] as? String)?.dateInISO8601()
        let pictureUrl = managerRepresentation["image"] as? String

        let manager = Manager(managerId: managerId,
                              name: name,
                              birthday: birthday,
                              pictureUrl: pictureUrl)

        return manager
    }

}

fileprivate struct Manager: ManagerProtocol {
    var managerId: String?
    var name: String?
    var birthday: Date?
    var pictureUrl: String?
}
