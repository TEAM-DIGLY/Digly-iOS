//
//  HeartRateDataModel.swift
//  digly
//
//  Created by Neoself on 10/25/24.
//
import CoreData

class HeartRateDataModel {
    static let shared = HeartRateDataModel()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HeartRateEntity")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func deleteOldData() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = HeartRateEntity.fetchRequest()
        // 동기화된 데이터만 삭제하도록 조건 추가
        fetchRequest.predicate = NSPredicate(format: "isSynced == YES")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        context.performAndWait {
            do {
                let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
                if let objectIDs = result?.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey: objectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.context])
                }
            } catch {
                print("Failed to delete old data: \(error)")
            }
        }
    }
}
