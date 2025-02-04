//
//  MoviesViewModel.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/2/25.
//

import Foundation

enum MoviesState {
    case initial
    case loading
    case success
    case failure
}

class MoviesViewModel {
    let networkManger: NetworkManager
    var error: NetworkManagerError?
    var state: MoviesState = .initial
    var data: [Movie] = []
    
    init(networkManger: NetworkManager = .shared) {
        self.networkManger = networkManger
    }
    
    func getPopularMovies(completion: @escaping ([Movie]) -> Void) {
        state = .loading
        networkManger.get(
            with: Endpoint.popularMovies,
            type: MovieResponse.self
        ) { [weak self] result in
            switch result {
                case let .success(result):
                    self?.state = .success
                    self?.data = result.results
                    completion(result.results)
                    return
                case let .failure(err):
                    self?.state = .failure
                    self?.error = err
                    completion([])
            }
        }
        
    }
    
    func getTrendingTodayMovies( completion: @escaping ([Movie]) -> Void) {
        state = .loading
        networkManger.get(
            with: Endpoint.trendingTodayMovies,
            type: MovieResponse.self
        ) { [weak self] result in
            switch result {
                case let .success(result):
                    self?.state = .success
                    self?.data = result.results
                    completion(result.results)
                case let .failure(err):
                    self?.state = .failure
                    self?.error = err
                    completion([])
                    
            }
        }
        
    }
    
    func getNowPlayingMovies( completion: @escaping ([Movie]) -> Void) {
        state = .loading
        networkManger.get(
            with: Endpoint.nowPlayingMovies,
            type: MovieResponse.self
        ) { [weak self] result in
            switch result {
                case let .success(result):
                    self?.state = .success
                    self?.data = result.results
                    completion(result.results)
                case let .failure(err):
                    self?.state = .failure
                    self?.error = err
                    completion([])
                    
            }
        }
        
    }
    
    func getUpcomingMovies( completion: @escaping ([Movie]) -> Void) {
        state = .loading
        networkManger.get(
            with: Endpoint.upcomingMovies,
            type: MovieResponse.self
        ) { [weak self] result in
            switch result {
                case let .success(result):
                    self?.state = .success
                    self?.data = result.results
                    completion(result.results)
                case let .failure(err):
                    self?.state = .failure
                    self?.error = err
                    completion([])
                    
            }
        }
        
    }
    
    func getTopRatedMovies( completion: @escaping ([Movie]) -> Void) {
        state = .loading
        networkManger.get(
            with: Endpoint.topRatedMovies,
            type: MovieResponse.self
        ) { [weak self] result in
            switch result {
                case let .success(result):
                    self?.state = .success
                    self?.data = result.results
                    completion(result.results)
                case let .failure(err):
                    self?.state = .failure
                    self?.error = err
                    completion([])
                    
            }
        }
        
    }
    
    func getPopularOnTV( completion: @escaping ([Movie]) -> Void) {
        state = .loading
        networkManger.get(
            with: Endpoint.discoverTV,
            type: MovieResponse.self
        ) { [weak self] result in
            switch result {
                case let .success(result):
                    self?.state = .success
                    self?.data = result.results
                    completion(result.results)
                case let .failure(err):
                    self?.state = .failure
                    self?.error = err
                    completion([])
                    
            }
        }
        
    }
    
    func getFreeToWatchMovies( completion: @escaping ([Movie]) -> Void) {
        state = .loading
        networkManger.get(
            with: Endpoint.discoverMovie,
            type: MovieResponse.self
        ) { [weak self] result in
            switch result {
                case let .success(result):
                    self?.state = .success
                    self?.data = result.results
                    completion(result.results)
                case let .failure(err):
                    self?.state = .failure
                    self?.error = err
                    completion([])
                    
            }
        }
        
    }
    
    func getSimilarMovies(movieId: Int, completion: @escaping ([Movie]) -> Void) {
        state = .loading
        networkManger.get(
            with: Endpoint.similar(type: "movie", id: movieId),
            type: MovieResponse.self
        ) { [weak self] result in
            switch result {
                case let .success(result):
                    self?.state = .success
                    self?.data = result.results
                    completion(result.results)
                case let .failure(err):
                    self?.state = .failure
                    self?.error = err
                    completion([])
                    
            }
        }
        
    }
    
    func getMovieCasts(movieId: Int, completion: @escaping ([Cast]) -> Void) {
        state = .loading
        networkManger.get(
            with: Endpoint.credit(type: "movie", id: movieId),
            type: CastResponse.self
        ) { [weak self] result in
            switch result {
                case let .success(result):
                    self?.state = .success
                    completion(result.cast)
                case let .failure(err):
                    self?.state = .failure
                    self?.error = err
                    completion([])
                    
            }
        }
    }
}
