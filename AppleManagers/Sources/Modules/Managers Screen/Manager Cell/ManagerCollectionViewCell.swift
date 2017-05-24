//
//  ManagerCollectionViewCell.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import ManagersAPI

final class ManagerCollectionViewCell: UICollectionViewCell, Registrable {

    @IBOutlet weak var managerImageView: UIImageView!
    @IBOutlet weak var managerNameLabel: UILabel!
    @IBOutlet weak var managerBirthdayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor(red:228/255.0, green:228/255.0, blue:228/255.0, alpha:0.75).cgColor
    }

    func configure(with manager: ManagerProtocol, imageDownloader: DownloadingImage? = nil) {
        self.managerImageView.image = nil
        self.managerNameLabel.text = manager.name
        self.managerBirthdayLabel.text = birthdayStringForLabel(with: manager.birthday)
        guard let imageDownloader = imageDownloader else {
            self.downloadImageIfNeed(urlInString: manager.pictureUrl)
            return
        }
        imageDownloader.downloadImageIfNeed(urlInString: manager.pictureUrl)
    }

    fileprivate static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    func birthdayStringForLabel(with date: Date?) -> String {
        guard let date = date else {
            return "🎂: not informed"
        }
        let dateInString = ManagerCollectionViewCell.dateFormatter.string(from: date)
        return "🎂  \(dateInString)  🎂"
    }

}

extension ManagerCollectionViewCell: DownloadingImage {

    func imageViewToApplyImage() -> UIImageView {
        return self.managerImageView
    }
}
