//
//  DatabaseManager.swift
//  EmpBook
//
//  Created by A118830248 on 11/10/22.
//

import Foundation
import CoreData
import UIKit

protocol MovieStorageProtocol {
    func saveOrUpdate(objects: [Movie], type: String) throws
    func getMovies(type: String) -> [Movie]
}

protocol CommentStorageProtocol {
    func saveCommentForMovieId(id: Int, comment: String) throws
    func fetchCommentForMovie(id: Int) throws -> String?
}

typealias StorageProtocol = MovieStorageProtocol & CommentStorageProtocol

final class DatabaseManager: StorageProtocol {
    
    private init() {}
    
    static let shared = DatabaseManager()
    private lazy var context: NSManagedObjectContext = {
        return PersistenceController.shared.container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        return PersistenceController.shared.container
    }()
    
    func getMovies(type: String) -> [Movie] {
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", type)
        do {
            let movies = try context.fetch(request)
            var movie = Movie()
            let result = movies.map({ movie.mapFromEntity(movieEntity: $0) })
            return result
        } catch {
            print(error)
            return []
        }
    }
    
    func getMovieEntities() -> [MovieEntity] {
        let context = PersistenceController.shared.container.viewContext
        do {
            let request = MovieEntity.fetchRequest()
            let movies = try context.fetch(request)
            return movies
        } catch {
            print(error)
            return []
        }
    }
    
    func saveOrUpdate(objects: [Movie], type: String) throws {
        
        let context = PersistenceController.shared.container.viewContext
        
         for item in objects {
             let request = MovieEntity.fetchRequest()
             request.predicate = NSPredicate(format: "id == %i", item.id ?? 0)
             
             var topEntity: MovieEntity
             if let result = try context.fetch(request).first {
                topEntity = result
             } else {
                 topEntity = MovieEntity(context: context)
             }
             topEntity = item.mapToMO(movieEntity: topEntity)
             topEntity.type = type
         }
        
        try context.save()
         
    }
}

extension DatabaseManager {
    
    func saveCommentForMovieId(id: Int, comment: String) throws {
        let context = PersistenceController.shared.container.viewContext
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", id)
        if let result = try context.fetch(request).first {
            result.comment = comment
        }
        
        try context.save()
    }
    
    func fetchCommentForMovie(id: Int) throws -> String? {
        let context = PersistenceController.shared.container.viewContext
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", id)
        let movies = try context.fetch(request)
        return movies.first?.comment
    }
}
