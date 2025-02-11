//
//  Movie.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 1/31/25.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}

struct Movie: Codable {
    let id: Int
    let title: String?
    let name: String?
    let posterPath: String
    let overview: String
    let releaseDate: String?
    let genreIds: [Int]
    let adult: Bool
    let originalTitle: String?
    let originalLanguage: String?
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool?
    let voteAverage: Double
    var imageUrl: URL? {
        let urlString = "\(Constants.imageBaseURL)\(self.posterPath)"
        return URL(string: urlString)
    }
    var backdropImageUrl: URL? {
        guard let backdrop = self.backdropPath else {
            return imageUrl
        }
        let urlString = "\(Constants.imageBaseURL)\(backdrop)"
        return URL(string: urlString)
    }
    
    func toFavorite(favorite: Favorite) {
        favorite.id = Int64(id)
        favorite.name = name
        favorite.title = title
        favorite.backdropPath = backdropPath
        favorite.posterPath = posterPath
        favorite.overview = overview
        favorite.voteAverage = voteAverage
        favorite.voteCount = Int64(voteCount)
        favorite.releaseDate = releaseDate
        favorite.originalTitle = originalTitle
        favorite.originalLanguage = originalLanguage
        favorite.adult = adult
    }
}

let moviesData: [Movie] = (
    Bundle.main.decode("movies") as MovieResponse
).results


let discoverData: [Movie] = (
    Bundle.main.decode("discover") as MovieResponse
).results


let popularData: [Movie] = (
    Bundle.main.decode("popular") as MovieResponse
).results
