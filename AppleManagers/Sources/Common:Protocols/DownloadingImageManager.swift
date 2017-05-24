//
//  DownloadingImageManager.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 31/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import Alamofire

protocol DownloadingImage {

    func downloadCompletionBlock() -> ((Bool) -> Void)?
    func imageViewToApplyImage() -> UIImageView
    func errorImage() -> UIImage
    func finishImageDownload(response: Alamofire.DataResponse<UIImage>)
    func failingToDownloadImage()
    func downloadImageIfNeed(urlInString: String?)

}

extension DownloadingImage {

    func downloadImageIfNeed(urlInString: String?) {
        if let urlInString = urlInString, let url = URL(string: urlInString) {
            imageViewToApplyImage().af_setImage(
                withURL: url,
                completion:finishImageDownload
            )
        }
    }

    func finishImageDownload(response: Alamofire.DataResponse<UIImage>) {
        let isEverythingOk = response.result.isSuccess
        if !isEverythingOk {
            failingToDownloadImage()
        }
        downloadCompletionBlock()?(isEverythingOk)

    }

    func failingToDownloadImage() {
        imageViewToApplyImage().image = errorImage()
    }

    func errorImage() -> UIImage {
        return #imageLiteral(resourceName: "error")
    }
    func downloadCompletionBlock() -> ((Bool) -> Void)? {
        return nil
    }
}
