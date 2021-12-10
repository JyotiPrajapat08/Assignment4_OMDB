//
//  CoreService.swift
//  OMDB
//
//  Created by user193869 on 05/12/21.
//

import Foundation
import CoreData
import UIKit

func createData(movie: JSON.Search.Movie) {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let userEntity = NSEntityDescription.entity(forEntityName: "Movies", in: managedContext)!
    
    
    let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
    user.setValue(movie.imdbID, forKey: "id")
    user.setValue(movie.title, forKeyPath: "title")
    user.setValue(movie.poster, forKey: "poster")
    user.setValue(movie.year, forKey: "year")
    user.setValue(movie.type, forKey: "type")
    
    do {
        try managedContext.save()
        
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

func getSavedData() -> [Movies]? {
    
    //As we know that container is set up in the AppDelegates so we need to refer that container.
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        do {
//            let movies = try managedContext.fetch(Movies.fetchRequest())
            if let result = try managedContext.fetch(fetchRequest) as? [Movies] {
                return result
            }
        } catch {
            
            print("Failed")
        }
    }
    return nil
}

//remain
func deleteData(id: String) {
    
    //As we know that container is set up in the AppDelegates so we need to refer that container.
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    //We need to create a context from this container
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
    fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
    
    do
    {
        let test = try managedContext.fetch(fetchRequest)
        
        let objectToDelete = test[0] as! NSManagedObject
        managedContext.delete(objectToDelete)
        
        do{
            try managedContext.save()
        }
        catch
        {
            print(error)
        }
        
    }
    catch
    {
        print(error)
    }
}


extension Movies: Encodable {
    
    private enum CodingKeys: String, CodingKey { case id, poster = "Poster", title = "Title", type = "Type", year = "Year" }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(poster, forKey: .poster)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        try container.encode(year, forKey: .year)
    }
}
