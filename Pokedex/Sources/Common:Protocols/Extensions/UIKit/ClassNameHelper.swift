//
//  ClassNameHelper.swift
//  Pokedex
//
//  Created by Antoine Barrault on 26/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit

public func classShortName(_ any: AnyClass) -> String {
    return "\(any)".components(separatedBy: ".").last ?? "\(any)"
}
