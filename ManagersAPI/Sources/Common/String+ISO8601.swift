//
//  String+ISO8601.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation

public extension String {

    private static let formatter = ISO8601DateFormatter()

    func dateInISO8601() -> Date? {
        return String.formatter.date(from: self)
    }
}
