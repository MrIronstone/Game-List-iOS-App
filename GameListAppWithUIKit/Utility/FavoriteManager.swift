//
//  FavoriteManager.swift
//  GameListAppWithUIKit
//
//  Created by admin on 4.02.2024.
//

import Foundation
import CoreData

class FavoriteManager {
    static let shared = FavoriteManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteGamesDataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        })
        let path = NSPersistentContainer.defaultDirectoryURL()
        print(path)
        return container
      }()
      
      //4
      func saveContext () {
        let context = FavoriteManager.shared.persistentContainer.viewContext
        if context.hasChanges {
          do {
            try context.save()
          } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
        }
      }
    
    func checkIsFavorite(id: Int) -> Bool {
        let context = FavoriteManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)
        
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Could not fetch. \(error)")
            return false
        }
    }

    
    func addToFavorite(id: Int) {
        let newGame = GameEntity(context: FavoriteManager.shared.persistentContainer.viewContext)
        newGame.id = Int16(id)

        self.saveContext()
    }
    
    func removeFromFavorite(id: Int) {
        let context = FavoriteManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)
        
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                let objects = try context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object)
                }
                saveContext()
            } else {
               print("Couldn't find any record")
            }
        } catch {
            print("Could not fetch so couldn't delete. \(error)")
        }
    }
    
    func allGames(result: @escaping (Result<[GameEntity], Error>) -> Void) {
        let context = FavoriteManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
        do {
            guard let games = try context.fetch(fetchRequest) as? [GameEntity] else { return }
            result(.success(games))
        } catch {
            result(.failure(error))
        }
    }
}
