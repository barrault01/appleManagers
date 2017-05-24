//
//  ManagerProtocol.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation

public protocol ManagerProtocol {
    var managerId: String? { get set }
    var name: String? { get set }
    var birthday: Date? { get set }
    var pictureUrl: String? { get set }

}

public protocol ManagerArquiver {
    func receivedManagers(managers: [ManagerProtocol])
}
