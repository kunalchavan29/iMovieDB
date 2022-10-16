//
//  MovieEntity+CoreDataProperties.swift
//  iMovieTest
//
//  Created by A118830248 on 16/10/22.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var id: Int32
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var video: Bool
    @NSManaged public var comment: String?

}

extension MovieEntity : Identifiable {

}
