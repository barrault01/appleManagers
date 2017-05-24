//
//  CoreDataArquiver.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation
import CoreData
import ManagersAPI

final class CoreDataArquiver {

    var context: NSManagedObjectContext!

    fileprivate func saveMainContext() {
        self.context.perform {
            do {
                try self.context.save()
            } catch {
                print("error saving main context: \(error)")
            }
        }
    }
}

extension CoreDataArquiver: ManagerArquiver {

    func receivedManagers(managers: [ManagerProtocol]) {
        self.save(managers: managers)
    }

    private func save(managers: [ManagerProtocol]) {

        let temporaryContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        temporaryContext.parent = self.context
        temporaryContext.perform {
            for manager in managers {
                _ = Manager.createManager(manager, in: temporaryContext)
            }
            do {
                try temporaryContext.save()
                self.saveMainContext()
            } catch let error as NSError {
                print("Could not save Manager. Error = \(error)")
            }
        }
    }

}
