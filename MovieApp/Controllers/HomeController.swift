//
//  ViewController.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 1/31/25.
//

import UIKit
import Combine

class HomeController: UIViewController {

    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var freeToWatchCollectionView: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let movieViewModel = MoviesViewModel()
    let tvShowsViewModel = TVShowsViewModel()
    var cancellables: Set<AnyCancellable> = []
    var trendingMovies: [Movie] = []
    var popularOnTVData: [Movie] = []
    var freeToWatchMoviesData: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        registerNIB()
        
        tvShowsViewModel.getDiscoverTVShows()
        movieViewModel.getTrendingTodayMovies()
        movieViewModel.getFreeToWatchMovies()
        setupBindings()
    }
    
    private func registerNIB() {
        trendingCollectionView
            .register(
                UINib(nibName: MoviesCollectionViewCell.identifier, bundle: nil),
                forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier
            )
        
        popularCollectionView
            .register(
                UINib(nibName: MoviesCollectionViewCell.identifier, bundle: nil),
                forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier
            )
        
        freeToWatchCollectionView
            .register(
                UINib(nibName: MoviesCollectionViewCell.identifier, bundle: nil),
                forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier
            )
    }
    
    private func setupBindings() {
        
        movieViewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("DEBUG PRINT: Error!!!!! \(error)")
                }
            } receiveValue: {[weak self] data in
                self?.trendingMovies = data
                self?.trendingMovies.shuffle()
                self?.trendingCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        
        tvShowsViewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("DEBUG PRINT: Error!!!!! \(error)")
                }
            } receiveValue: {[weak self] data in
                self?.popularOnTVData = data
                self?.popularOnTVData.shuffle()
                self?.popularCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        
//        movieViewModel.getFreeToWatchMovies { [weak self] data in
//            DispatchQueue.main.async {
//                self?.freeToWatchMoviesData = data
//                self?.freeToWatchMoviesData.shuffle()
//                self?.freeToWatchCollectionView.reloadData()
//            }
//        }
    }

}


// MARK: - UICollectionViewDataSource
extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case trendingCollectionView:
                return trendingMovies.count
            case popularCollectionView:
                return popularOnTVData.count
            case freeToWatchCollectionView:
                return freeToWatchMoviesData.count
            default:
                return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviesCollectionViewCell.identifier,
            for: indexPath
        ) as! MoviesCollectionViewCell
        cell.setupConstraints()
        switch collectionView {
            case trendingCollectionView:
                cell.setup(movie: trendingMovies[indexPath.row])
                return cell
            case popularCollectionView:
                cell.setup(movie: popularOnTVData[indexPath.row])
                return cell
            case freeToWatchCollectionView:
                cell.setup(movie: freeToWatchMoviesData[indexPath.row])
                return cell
            default:
                return UICollectionViewCell()
        }
       
    }
}

// MARK: - UICollectionViewDelegate
extension HomeController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewController(
            identifier: "DetailViewController"
        ) as! DetailViewController
        
        switch collectionView {
            case trendingCollectionView:
                viewcontroller.movie = trendingMovies[indexPath.row]
            case popularCollectionView:
                viewcontroller.movie = popularOnTVData[indexPath.row]
            case freeToWatchCollectionView:
                viewcontroller.movie = freeToWatchMoviesData[indexPath.row]
            default:
                break
        }
        
        viewcontroller.modalPresentationStyle = .fullScreen
        viewcontroller.heroModalAnimationType = .fade
        present(viewcontroller, animated: true)
    }
}
