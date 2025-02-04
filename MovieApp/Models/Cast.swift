//
//  Credit.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/3/25.
//

import Foundation

struct CastResponse: Codable {
    let id: Int?
    let cast: [Cast]
}

struct Cast: Codable {
    let id: Int
    let adult: Bool
    let gender: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castId: Int
    let character: String
    let creditId: String
    let order: Int
    var profileImageUrl: URL? {
        guard let imageUrl = self.profilePath else {
            return nil
        }
        let urlString = "\(Constants.imageBaseURL)\(imageUrl)"
        return URL(string: urlString)
    }
}

let castsData: [Cast] = (
    Bundle.main.decode("casts") as CastResponse
).cast
