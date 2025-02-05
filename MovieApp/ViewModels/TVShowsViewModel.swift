//
//  TVShowsViewModel.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/5/25.
//

import Foundation
import Combine

enum TVShowsState {
    case initial,
    loading,
    success,
    failure
}
class TVShowsViewModel: ObservableObject {
    @Published var data: [Movie] = []
    @Published var state: TVShowsState = .initial
    @Published var error: NetworkManagerError?
    var cancellables: Set<AnyCancellable> = []
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getPopularTVShows() {
        state = .loading
        getAsPublisher(with: Endpoint.popularTV)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        print("Completed")
                        self?.state = .success
                    case .failure(let error):
                        self?.state = .failure
                        print("Error \(error)")
                        self?.error = error
                }
            } receiveValue: {[weak self] data in
                self?.data = data.results
            }
            .store(in: &cancellables)

    }
    
    func getairingTodayTVShows() {
        getAsPublisher(with: Endpoint.trendingTodayTV)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        print("Completed")
                    case .failure(let error):
                        print("Error \(error)")
                        self?.error = error
                }
            } receiveValue: {[weak self] data in
                self?.data = data.results
            }
            .store(in: &cancellables)
        
    }
    
    func getTopRatedTVShows() {
        getAsPublisher(with: Endpoint.topRatedTV)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        print("Completed")
                    case .failure(let error):
                        print("Error \(error)")
                        self?.error = error
                }
            } receiveValue: {[weak self] data in
                self?.data = data.results
            }
            .store(in: &cancellables)
        
    }
    
//    func getTopRatedTVShows() {
//        getAsPublisher(with: Endpoint.o)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                switch completion {
//                    case .finished:
//                        print("Completed")
//                    case .failure(let error):
//                        print("Error \(error)")
//                        self?.error = error
//                }
//            } receiveValue: {[weak self] data in
//                self?.data = data.results
//            }
//            .store(in: &cancellables)
//        
//    }
}

func getAsPublisher(with endpoint: Endpoint) ->  Future<MovieResponse, NetworkManagerError> {
    return Future { promise in
        NetworkManager.shared
            .get(with: endpoint, type: MovieResponse.self) { result in
                switch result {
                    case let .success(data):
                        promise(.success(data))
                    case let .failure(error):
                        promise(.failure(error))
                }
            }
    }
}
