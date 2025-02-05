//
//  MoviesViewModel.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/2/25.
//

import Foundation
import Combine

enum MoviesState {
    case initial
    case loading
    case success
    case failure
}

class MoviesViewModel: ObservableObject {
    let networkManger: NetworkManager
    @Published var error: NetworkManagerError?
    @Published var state: MoviesState = .initial
    @Published var data: [Movie] = []
    var cancellables: Set<AnyCancellable> = []
    
    init(networkManger: NetworkManager = .shared) {
        self.networkManger = networkManger
    }
    
    func getPopularMovies() {
        state = .loading
        networkManger
            .getPublisher(
                with: Endpoint.popularMovies,
                type: MovieResponse.self
            )
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                switch completion {
                    case .finished:
                        self?.state = .success
                    case .failure(let error):
                        self?.state = .failure
                        self?.error = error
                }
            } receiveValue: {[weak self] data in
                self?.data = data.results
            }
            .store(in: &cancellables)
        
    }
    
    func getTrendingTodayMovies() {
        state = .loading
        networkManger
            .getPublisher(
                with: Endpoint.trendingTodayMovies,
                type: MovieResponse.self
            )
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                switch completion {
                    case .finished:
                        self?.state = .success
                    case .failure(let error):
                        self?.state = .failure
                        self?.error = error
                }
            } receiveValue: {[weak self] data in
                self?.data = data.results
            }
            .store(in: &cancellables)
    }
    
    func getNowPlayingMovies() {
        state = .loading
        networkManger
            .getPublisher(
                with: Endpoint.nowPlayingMovies,
                type: MovieResponse.self
            )
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                switch completion {
                    case .finished:
                        self?.state = .success
                    case .failure(let error):
                        self?.state = .failure
                        self?.error = error
                }
            } receiveValue: {[weak self] data in
                self?.data = data.results
            }
            .store(in: &cancellables)
    }
    
    func getUpcomingMovies() {
        state = .loading
        networkManger
            .getPublisher(
                with: Endpoint.upcomingMovies,
                type: MovieResponse.self
            )
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                switch completion {
                    case .finished:
                        self?.state = .success
                    case .failure(let error):
                        self?.state = .failure
                        self?.error = error
                }
            } receiveValue: {[weak self] data in
                self?.data = data.results
            }
            .store(in: &cancellables)
    }
    
    func getTopRatedMovies() {
        state = .loading
        networkManger
            .getPublisher(
                with: Endpoint.topRatedMovies,
                type: MovieResponse.self
            )
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                switch completion {
                    case .finished:
                        self?.state = .success
                    case .failure(let error):
                        self?.state = .failure
                        self?.error = error
                }
            } receiveValue: {[weak self] data in
                self?.data = data.results
            }
            .store(in: &cancellables)
        
    }
    
    func getFreeToWatchMovies() {
        state = .loading
        networkManger
            .getPublisher(
                with: Endpoint.discoverMovie,
                type: MovieResponse.self
            )
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                switch completion {
                    case .finished:
                        self?.state = .success
                    case .failure(let error):
                        self?.state = .failure
                        self?.error = error
                }
            } receiveValue: {[weak self] data in
                self?.data = data.results
            }
            .store(in: &cancellables)
    }
}
