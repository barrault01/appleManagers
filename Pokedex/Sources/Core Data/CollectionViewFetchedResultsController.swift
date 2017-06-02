//
//  CollectionViewFetchedResultsController.swift
//
//  Created by Antoine Barrault
//

import UIKit
import CoreData

// swiftlint:disable:next line_length
class CollectionViewFetchedResultsController<T: NSFetchRequestResult> : NSObject, NSFetchedResultsControllerDelegate, FiltrableCollectionDataSource {

    func filter(with string: String, for parameter: String) {
        if string.characters.count > 0 {
            fetchedResults.fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", string)
        } else {
            fetchedResults.fetchRequest.predicate = nil
        }
        try? self.fetchedResults.performFetch()
        self.collectionView?.reloadData()

    }

    var  onUpdateMethod: (() -> Void)?

    fileprivate lazy var fetchedResults: NSFetchedResultsController<T> = {
        let fetchResultsController = NSFetchedResultsController(fetchRequest: self.request,
                                                                managedObjectContext: self.managedObjectContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()

    var collectionView: UICollectionView?
    fileprivate var request: NSFetchRequest<T>
    fileprivate var managedObjectContext: NSManagedObjectContext
    fileprivate var sectionChanges: [(NSFetchedResultsChangeType, Int)]?
    fileprivate var itemChanges: [(NSFetchedResultsChangeType, [IndexPath])]?
    fileprivate var shouldReloadCollectionView: Bool = false

    init(collectionView: UICollectionView? = nil,
         request: NSFetchRequest<T>,
         managedObjectContext: NSManagedObjectContext) {
        self.collectionView = collectionView
        self.request = request
        self.managedObjectContext = managedObjectContext
    }

    func performFetch() throws {
        try fetchedResults.performFetch()
    }

    func object(at indexPath: IndexPath) -> Any? {
        return self.fetchedResults.object(at: indexPath)
    }

    func numberOfobjects(for sectionIndex: Int) -> Int {
        guard let sections = fetchedResults.sections else {
            return 0
        }
        return sections[sectionIndex].numberOfObjects
    }

    @objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sectionChanges = [(NSFetchedResultsChangeType, Int)]()
        itemChanges = [(NSFetchedResultsChangeType, [IndexPath])]()
    }

    @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                          didChange sectionInfo: NSFetchedResultsSectionInfo,
                          atSectionIndex sectionIndex: Int,
                          for type: NSFetchedResultsChangeType) {
        sectionChanges?.append((type, sectionIndex))
    }

    @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                          didChange anObject: Any,
                          at indexPath: IndexPath?,
                          for type: NSFetchedResultsChangeType,
                          newIndexPath: IndexPath?) {
        guard  let collectionView = collectionView else {
            return
        }
        let change: (NSFetchedResultsChangeType, [IndexPath])
        switch type {
        case .insert:
            if collectionView.numberOfSections > 0 {
                if collectionView.numberOfItems(inSection: newIndexPath!.section) == 0 {
                    self.shouldReloadCollectionView = true
                    return
                } else {
                    change = (type, [newIndexPath!])
                }
            } else {
                self.shouldReloadCollectionView = true
                return
            }
        case .delete:
            if collectionView.numberOfItems(inSection: indexPath!.section) == 1 {
                self.shouldReloadCollectionView = true
                return
            }
            change = (type, [indexPath!])
        case .update:change = (type, [indexPath!])
        case .move:change = (type, [indexPath!, newIndexPath!])
        }
        itemChanges?.append(change)
    }

    @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        guard let sectionChanges = sectionChanges,
            let itemChanges = itemChanges,
            let collectionView = self.collectionView else {
                return
        }
        //when collectionView is not visible and if it is not the firt insertion or last remotion
        guard shouldReloadCollectionView == false && collectionView.window != nil  else {
            collectionView.reloadData()
            self.finishUpdating()
            return
        }

        updateCollectionView(sectionChanged: sectionChanges, itemsChanged: itemChanges)
    }

    func updateCollectionView(sectionChanged: [(NSFetchedResultsChangeType, Int)],
                              itemsChanged: [(NSFetchedResultsChangeType, [IndexPath])]) {

        guard  let collectionView = collectionView else {
            self.finishUpdating()
            return
        }

        collectionView.performBatchUpdates({
            for change in sectionChanged {
                switch change.0 {
                case .insert:collectionView.insertSections(IndexSet(integer: change.1))
                case .delete:collectionView.deleteSections(IndexSet(integer: change.1))
                case .move, .update: break
                }
            }
            for change in itemsChanged {
                switch change.0 {
                case .insert:collectionView.insertItems(at: change.1)
                case .delete:collectionView.deleteItems(at: change.1)
                case .update: collectionView.reloadItems(at: change.1)
                case .move:collectionView.moveItem(at: change.1[0], to: change.1[1])
                }
            }

        }, completion: { _ in
            self.finishUpdating()
        })
    }

    func finishUpdating() {
        self.sectionChanges = nil
        self.itemChanges = nil
        if let onUpdateMethod = self.onUpdateMethod {
            onUpdateMethod()
        }

    }
}
