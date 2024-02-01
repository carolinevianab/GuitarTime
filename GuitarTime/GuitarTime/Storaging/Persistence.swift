//
//  Persistence.swift
//  GuitarTime
//
//  Created by Caroline Viana on 23/08/23.
//

import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let c1 = PersistenceService.convertSingleToGuitarClass(content: classType1, context: viewContext)
        let c2 = PersistenceService.convertSingleToGuitarClass(content: classType2, context: viewContext)
        let c3 = PersistenceService.convertSingleToGuitarClass(content: classType3, context: viewContext)
        
        let m1 = PersistenceService.convertSingleToGuitarModule(content: moduleType1, context: viewContext)
        let m2 = PersistenceService.convertSingleToGuitarModule(content: moduleType2, context: viewContext)
        let m3 = PersistenceService.convertSingleToGuitarModule(content: moduleType3, context: viewContext)
        
        let ch1 = PersistenceService.convertSingleToChord(content: chordType1, context: viewContext)
        let ch2 = PersistenceService.convertSingleToChord(content: chordType2, context: viewContext)
        let ch3 = PersistenceService.convertSingleToChord(content: chordType3, context: viewContext)
        
        let cl1 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted1, context: viewContext)
        let cl2 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted2, context: viewContext)
        let cl3 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted3, context: viewContext)
        let cl4 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted4, context: viewContext)
        let cl5 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted5, context: viewContext)
        
        let cl6 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted6, context: viewContext)
        let cl7 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted7, context: viewContext)
        let cl8 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted8, context: viewContext)
        let cl9 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted9, context: viewContext)
        let cl10 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted10, context: viewContext)
        let cl11 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted11, context: viewContext)
        let cl12 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted12, context: viewContext)
        let cl13 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted13, context: viewContext)
        let cl14 = PersistenceService.convertSingleToCompletedClass(content: dayCompleted14, context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GuitarTime")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
}
