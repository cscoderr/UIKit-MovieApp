//
//  DetailsViewModel.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/5/25.
//

import Foundation
import Combine

enum DetailsState {
    case initial
    case loading
    case success
    case failure
}

class DetailsViewModel: ObservableObject {
    let networkManger: NetworkManager
    @Published var error: NetworkManagerError?
    @Published var state: DetailsState = .initial
    @Published var data: [Movie] = []
    @Published var castsData: [Cast] = []
    var cancellables: Set<AnyCancellable> = []
    
    init(networkManger: NetworkManager = .shared) {
        self.networkManger = networkManger
    }
    
    func getSimilarMovies(movieId: Int) {
        state = .loading
        networkManger
            .getPublisher(
                with: Endpoint.similar(type: "movie", id: movieId),
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
    
    func getMovieCasts(movieId: Int) {
        state = .loading
        networkManger
            .getPublisher(
                with: Endpoint.credit(type: "movie", id: movieId),
                type: CastResponse.self
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
                self?.castsData = data.cast
            }
            .store(in: &cancellables)
    }
}
