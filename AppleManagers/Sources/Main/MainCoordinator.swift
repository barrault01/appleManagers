//
//  MainCoordinator.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 25/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import UIKit
import ManagersAPI

class MainCoordinator: Coordinator {

    fileprivate unowned let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showManagersList()
    }

}

extension MainCoordinator {

    func showManagersList() {

        let api = ManagerAPI()
        let managerDataSource = Manager.fetchResultsControllerForOrdered()
        let arquiver = CoreDataArquiver()
        arquiver.context = CoreDataStack.shared.managedObjectContext
        let rootCoordinator = ManagerCoordinator(window: self.window,
                                                 api: api,
                                                 managerDataSource:managerDataSource,
                                                 managerArquiver: arquiver)
        rootCoordinator.start()
    }

}
