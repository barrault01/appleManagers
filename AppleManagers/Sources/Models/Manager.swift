//
//  Manager.swift
//  AppleManagers
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation
import CoreData
import ManagersAPI

final class Manager: NSManagedObject, ManagerProtocol {

    @NSManaged public var managerId: String?
    @NSManaged public var name: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var pictureUrl: String?

    static func createManager(_ manager: ManagerProtocol, in context: NSManagedObjectContext) -> Manager? {
        guard let managerId = manager.managerId else {
            return nil
        }

        var managerObject: Manager?
        let request = uniqueManageFetchRequest(managerId: managerId, in: context)
        if let managers = try? context.fetch(request), let obj = managers.first {
            managerObject = obj
        } else {
            managerObject = createManager(in: context)
        }
        managerObject?.configure(using: manager)
        return managerObject
    }

    static func fetchResultsControllerForOrdered() -> CollectionViewFetchedResultsController<Manager> {

        let request = NSFetchRequest<Manager>(entityName: "Manager")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        let context = CoreDataStack.shared.managedObjectContext
        let managers =
            CollectionViewFetchedResultsController<Manager>(request: request,
                                                            managedObjectContext: context!)
        return managers
    }

}

fileprivate extension Manager {

    static func uniqueManageFetchRequest(managerId: String,
                                         in context: NSManagedObjectContext) -> NSFetchRequest<Manager> {
        let predicate = NSPredicate(format: "managerId = %@", managerId)
        let request = fetchRequest(in: context)
        request.predicate = predicate
        request.fetchLimit = 1
        return request
    }

    static func fetchRequest(in context: NSManagedObjectContext) -> NSFetchRequest<Manager> {
        let entity = NSEntityDescription.entity(forEntityName: "Manager", in: context)
        let request = NSFetchRequest<Manager>()
        request.entity = entity
        return request
    }

    static func createManager(in context: NSManagedObjectContext) -> Manager? {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: "Manager", into: context) as? Manager else {
            assertionFailure("we could not create a Manager something goes wrong")
            return nil
        }
        return obj
    }

    func configure(using manager: ManagerProtocol) {
        self.managerId = manager.managerId
        self.name = manager.name
        self.birthday = manager.birthday
        self.pictureUrl = manager.pictureUrl
    }

}
