//
//  Endpoint.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/2/25.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Endpoint {
    case popularMovies
    case popularTV
    case trendingTodayMovies
    case nowPlayingMovies
    case upcomingMovies
    case topRatedMovies
    case airingTodayTV
    case trendingTodayTV
    case topRatedTV
    case movieGenre
    case tvGenre
    case discoverMovie
    case discoverTV
    case allTrending
    case credit(type: String, id: Int)
    case similar(type: String, id: Int)
//    case nowPlayingMovies
//    case trendingMovies
//    case tendingSeries
//    case airingToday
//    case popularSeries
    
    private var url: URL? {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            print("Info.plist is missing")
            fatalError("Info.plist file is missing")
        }
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.path = "/3\(self.path)"
        guard let apiKey = infoDictionary["API_KEY"] as? String else {
            print("API KEY is missing")
            fatalError("API KEY is missing")
        }
        var queryItems = self.queryItems
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components.queryItems = queryItems
        return components.url
    }
    
    var request: URLRequest? {
        guard let url = self.url else {
            print("Url is null")
            return nil
        }
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.rawValue
        request.httpBody = nil
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private var path: String {
        switch self {
            case .popularMovies:
                return "/movie/popular"
            case .popularTV:
                return "/tv/popular"
            case .trendingTodayMovies:
                return "/trending/movie/day"
            case .nowPlayingMovies:
                return "/movie/now_playing"
            case .upcomingMovies:
                return "/movie/upcoming"
            case .topRatedMovies:
                return "/movie/top_rated"
            case .airingTodayTV:
                return "/tv/airing_today"
            case .trendingTodayTV:
                return "/trending/tv/day"
            case .topRatedTV:
                return "/tv/top_rated"
            case .movieGenre:
                return "/genre/movie/list"
            case .tvGenre:
                return "/genre/tv/list"
            case .discoverMovie:
                return "/discover/movie"
            case .discoverTV:
                return "/discover/tv"
            case .allTrending:
                return "/trending/all/day"
            case let .credit(type, id):
                return "/\(type)/\(id)/credits"
            case let .similar(type, id):
                return "/\(type)/\(id)/similar"
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
            case .popularMovies, .popularTV, .trendingTodayMovies, .nowPlayingMovies, .upcomingMovies, .topRatedMovies, .airingTodayTV, .trendingTodayTV, .topRatedTV, .movieGenre, .tvGenre, .discoverMovie, .discoverTV, .allTrending, .similar,
                    .credit:
                return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
//            case .popularMovie:
//                return [
////                    URLQueryItem(name: "api_key", value: "1"),
////                    URLQueryItem(name: "limit", value: "50"),
//                ]
//            case .popularTV:
//                return [
////                    URLQueryItem(name: "api_key", value: apiKey),
////                    URLQueryItem(name: "limit", value: "50"),
//                ]
            default:
                return []
        }
    }
}
