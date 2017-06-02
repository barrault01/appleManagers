//
//  CoreDataStack.swift
//  Pokedex
//
//  Created by Antoine Barrault on 24/05/2017.
//  Copyright © 2017 Antoine Barrault. All rights reserved.
//

import Foundation
import CoreData

fileprivate let databaseName = "Pokedex"

final class CoreDataStack {
    internal static let shared = CoreDataStack()

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last as URL!
    }()

    lazy var applicationStoresDirectory: URL? = {

        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        let url = (urls.last as URL!).appendingPathComponent("Stores")

        if fm.fileExists(atPath: url.path) == false {
            var error: NSError? = nil
            do {
                try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch var error1 as NSError {
                error = error1
            } catch {
                fatalError()
            }
            if error != nil {
                print("Unable to create directory for data stores.")
                return nil
            }
        }
        return url
    }()

    lazy var applicationIncompatibleStoresDirectory: URL? = {

        let fm = FileManager.default

        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        let url = self.applicationStoresDirectory!.appendingPathComponent("Incompatible")
        if fm.fileExists(atPath: url.path) == false {
            var error: NSError? = nil
            do {
                try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch var error1 as NSError {
                error = error1
            } catch {
                fatalError()
            }
            if error != nil {
                print("Unable to create directory for data stores.")
                return nil
            }
        }
        return url
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: databaseName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {

        var coordinator: NSPersistentStoreCoordinator? =
            NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(databaseName).sqlite")

        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."

        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType,
                                                configurationName: nil,
                                                at: url,
                                                options: options)
        } catch var error2 as NSError {
            error = error2
            coordinator = nil

            self.moveCorruptStore(url)
            // Report any error we got.
            coordinator =  NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            do {
                try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType,
                                                    configurationName: nil,
                                                    at: url,
                                                    options: options)
            } catch var error1 as NSError {
                error = error1
                abort()
            } catch {
                fatalError()
            }
        } catch {
            fatalError()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
                }
            }
        }
    }

    func nameForIncompatibleStore () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.formatterBehavior = .behavior10_4
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return "\(dateFormatter.string(from: Date())).sqlite"
    }

    func corruptURLCreator() -> URL? {
        return self.applicationIncompatibleStoresDirectory?.appendingPathComponent(nameForIncompatibleStore())
    }

    func moveCorruptStore (_ storeURL: URL) {
        let fm = FileManager.default
        if fm.fileExists(atPath: storeURL.path) {
            if let corruptURL  = corruptURLCreator() {
                var error: NSError? = nil
                do {
                    try fm.moveItem(at: storeURL, to: corruptURL)
                } catch let error1 as NSError {
                    error = error1
                }
                if error != nil {
                    print("Unable to move corrupt store.")
                }

            }
        }
    }
}
