//
//  NetworkManager.swift
//  CoreDataDemo
//
//  Created by Victor on 26.01.2022.
//

import CoreData
import UIKit

class StorageManager {
    static let shared = StorageManager()
    
// MARK: - Public Properties
    
    private var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
        return container
        }()
    
    lazy private var context = persistentContainer.viewContext
// MARK: - Initializers
    private init() {}
        
// MARK: - Public Methods
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()

        do {
            let taskList = try context.fetch(fetchRequest)
            completion(.success(taskList))
        } catch {
            print("Failed to fetch data", error)
            completion(.failure(error))
        }
    }

    func add(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: context)
        task.name = taskName
        completion(task)
        saveContext()
    }
    
    func editTask(_ task: Task, taskName: String) {
        task.name = taskName
        saveContext()
    }
    
    func deleteTask(at index: Int, for task: [Task]) {
        context.delete(task[index])
        saveContext()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
}
