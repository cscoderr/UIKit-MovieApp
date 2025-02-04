//
//  ViewController.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 1/31/25.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var freeToWatchCollectionView: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let movieViewModel = MoviesViewModel()
    var data: [Movie] = []
    var popularOnTVData: [Movie] = []
    var freeToWatchMoviesData: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
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
        
        movieViewModel.getTrendingTodayMovies { [weak self] data in
            DispatchQueue.main.async {
                self?.data = data
                self?.data.shuffle()
                self?.trendingCollectionView.reloadData()
            }
        }
        
        movieViewModel.getPopularOnTV { [weak self] data in
            DispatchQueue.main.async {
                self?.popularOnTVData = data
                self?.popularOnTVData.shuffle()
                self?.popularCollectionView.reloadData()
            }
        }
        
        movieViewModel.getFreeToWatchMovies { [weak self] data in
            DispatchQueue.main.async {
                self?.freeToWatchMoviesData = data
                self?.freeToWatchMoviesData.shuffle()
                self?.freeToWatchCollectionView.reloadData()
            }
        }
    }

}

// MARK: - UICollectionViewDataSource
extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case trendingCollectionView:
                return data.count
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
                cell.setup(movie: data[indexPath.row])
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
                viewcontroller.movie = data[indexPath.row]
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
