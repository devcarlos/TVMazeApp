//
//  FavoriteManager.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/29/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum FavoriteError: Error {
    case fetchError
    case saveError
    case deleteError
    case notFoundError
}

extension FavoriteError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fetchError:
            return "Failed to fetch favorite shows."
        case .saveError:
            return "Failed to save favorite show."
        case .deleteError:
            return "Failed to delete favorite show."
        case .notFoundError:
            return "Failed to find favorite show."

        }
    }
}

typealias FetchFavoriteHandler = (Result<[Show]?, FavoriteError>) -> Void

typealias SaveFavoriteHandler = (Result<Bool, FavoriteError>) -> Void

typealias DeleteFavoriteHandler = (Result<Bool, FavoriteError>) -> Void

typealias FindFavoriteHandler = (Result<Bool, FavoriteError>) -> Void

class FavoriteManager: NSObject {

    static let shared = FavoriteManager()
    
    //Initializer access level change now
    private override init(){}
    
    func saveFavorite(show: Show, completion: @escaping SaveFavoriteHandler) {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let showEntity = NSEntityDescription.entity(forEntityName: "FavoriteShow", in: managedContext)!
        
        //setup favorite show and save
        let favoriteShow = NSManagedObject(entity: showEntity, insertInto: managedContext)
        favoriteShow.setValue(show.id, forKeyPath: "showID")
        favoriteShow.setValue(show.name, forKey: "name")
        let rating = show.rating?.average ?? nil
        favoriteShow.setValue(rating, forKey: "rating")
        favoriteShow.setValue(show.genres, forKey: "genres")
        favoriteShow.setValue(show.schedule?.time, forKey: "time")
        favoriteShow.setValue(show.schedule?.days, forKey: "days")
        favoriteShow.setValue(show.image?.medium, forKey: "image")
        favoriteShow.setValue(show.summary, forKey: "summary")

        //try to save entity
        do {
            try managedContext.save()
            completion(.success(true))
        } catch let error {
            completion(.failure(.saveError))
            print("Error on Save: \(error.localizedDescription)")
        }
    }
    
    func fetchFavoriteShows(completion: @escaping FetchFavoriteHandler) {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteShow")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            var shows:[Show] = []
            
            guard let resultData = result as? [NSManagedObject] else {
                completion(.success(shows))
                return
            }
            
            for data in resultData {
                
                let id = (data.value(forKey: "showID") as! NSNumber).intValue
                let name = data.value(forKey: "name") as! String
                let genres = data.value(forKey: "genres") as? [String]
                
                let time = data.value(forKey: "time") as! String
                let days = data.value(forKey: "days") as! [String]
                let schedule = Schedule(time: time, days: days)
                
                let ratingValue = (data.value(forKey: "rating") as! NSNumber).floatValue
                let rating = Rating(average: ratingValue)
                let imageURL = data.value(forKey: "image") as! String
                let image = MazeImage(medium: imageURL, original: imageURL)
                let summary = data.value(forKey: "summary") as! String
                
                let show = Show(id: id, url: nil, name: name, type: nil, language: nil, genres: genres, status: nil, runtime: nil, premiered: nil, officialSite: nil, schedule: schedule, rating: rating, weight: nil, network: nil, webChannel: nil, externals: nil, image: image, summary: summary, updated: nil, _links: nil)
                
                shows.append(show)
            }
            
            //complete and send results
            completion(.success(shows))
            
        } catch let error {
            completion(.failure(.fetchError))
            print(error)
        }
    }
    
    func deleteFavorite(show: Show, completion: @escaping DeleteFavoriteHandler){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteShow")
        fetchRequest.predicate = NSPredicate(format: "showID = %d", show.id)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            guard let resultData = result as? [NSManagedObject], let object = resultData.first  else {
                completion(.failure(.notFoundError))
                return
            }
            
            managedContext.delete(object)
            
            do {
                try managedContext.save()
                completion(.success(true))
            } catch let error {
                completion(.failure(.deleteError))
                print(error)
            }
            
        } catch let error {
            completion(.failure(.deleteError))
            print(error)
        }
    }
    
    
    func findFavorite(show: Show, completion: @escaping FindFavoriteHandler){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteShow")
        fetchRequest.predicate = NSPredicate(format: "showID = %d", show.id)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            guard let resultData = result as? [NSManagedObject], let object = resultData.first  else {
                completion(.failure(.notFoundError))
                return
            }
            
            //found object
            _ = object.value(forKey: "name") as! String
            
            //complete with success
            completion(.success(true))
            
        } catch let error {
            //complete with failure
            completion(.failure(.notFoundError))
            print(error)
        }
    }
}
