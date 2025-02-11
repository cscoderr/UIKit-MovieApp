//
//  Favorite.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/11/25.
//

import Foundation
import CoreData

public class Favorite: NSManagedObject {
    var imageUrl: URL? {
        let urlString = "\(Constants.imageBaseURL)\(self.posterPath!)"
        return URL(string: urlString)
    }
    
    func asMovie() -> Movie {
        return Movie(
            id: Int(id),
            title: title,
            name: name,
            posterPath: posterPath ?? "",
            overview: overview ?? "",
            releaseDate: releaseDate,
            genreIds: [],
            adult: adult,
            originalTitle: originalTitle,
            originalLanguage: originalLanguage,
            backdropPath: backdropPath,
            popularity: popularity,
            voteCount: Int(voteCount),
            video: video,
            voteAverage: voteAverage
        )
    }
}

