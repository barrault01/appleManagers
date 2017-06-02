//
//  UIView+nib.swift
//  Pokedex
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit

extension UIView {

    static func nibForSelf() -> UINib? {
        let bundle = Bundle(for: self)
        let name = classShortName(self)
        guard let path = bundle.path(forResource: name, ofType: "nib"),
            FileManager.default.fileExists(atPath: path) else {
                return nil
        }
        return UINib(nibName: name, bundle: bundle)
    }

}
