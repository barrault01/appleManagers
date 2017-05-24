//
//  ManagerCoordinator.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import ManagersAPI

final class ManagerCoordinator: Coordinator {

    fileprivate unowned let window: UIWindow

    var currentViewController: UIViewController?
    var api: ManagerAPI
    var managerDataSource: CollectionDataSource
    var managerArquiver: ManagerArquiver
    init(window: UIWindow, api: ManagerAPI, managerDataSource: CollectionDataSource, managerArquiver: ManagerArquiver) {
        self.window = window
        self.api = api
        self.managerDataSource = managerDataSource
        self.managerArquiver = managerArquiver
    }

    func start() {

        api.fetchManagers { [unowned self] managers in
            self.managerArquiver.receivedManagers(managers: managers)
        }
        let storyboard = UIStoryboard(name: "Managers", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() as? ManagersViewController {
            let viewModel = ManagersViewModel(managersFetchController: managerDataSource)
            vc.viewModel = viewModel
            self.currentViewController = vc
            window.rootViewController = vc
        }
    }

}
