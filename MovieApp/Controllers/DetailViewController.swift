//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/2/25.
//

import UIKit
import Kingfisher
import Combine

class DetailViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backButtonImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    var movie: Movie!
    
    let detailsViewModel = DetailsViewModel()
    var cancellables: Set<AnyCancellable> = []
    var movieCastData: [Cast] = []
    var similarMovieData: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        
        similarCollectionView
            .register(
                UINib(
                    nibName: MoviesCollectionViewCell.identifier,
                    bundle: nil
                ),
                forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier
            )
        castCollectionView
            .register(
                UINib(nibName: CastCollectionViewCell.identifier, bundle: nil),
                forCellWithReuseIdentifier: CastCollectionViewCell.identifier
            )
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
//        similarCollectionView.collectionViewLayout = setupCompositionalLayout()
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            backButtonImageView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButtonImageView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 20),
            backButtonImageView.widthAnchor.constraint(equalToConstant: 24),
            backButtonImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        posterImageView.heroID = "moviePosterImage_\(movie.id)"
        backgroundImageView.kf.indicatorType = .activity
        posterImageView.kf.indicatorType = .activity
        backgroundImageView.kf
            .setImage(
                with: movie.backdropImageUrl,
                options: [.transition(.fade(0.3))]
            )
        posterImageView.kf.setImage(with: movie.imageUrl, options: [.transition(.fade(0.3))])
        
        backButtonImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(backButtonPressed))
        backButtonImageView.addGestureRecognizer(tapGesture)
        
        detailsViewModel.getMovieCasts(movieId: movie.id)
        detailsViewModel
            .getSimilarMovies(movieId: movie.id)
        
        setupBindings()

    }
    
    @objc func backButtonPressed(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    private func setupBindings() {
        detailsViewModel.$castsData
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("DEBUG PRINT: Error!!!!! \(error)")
                }
            } receiveValue: {[weak self] data in
                self?.movieCastData = data
                self?.movieCastData.shuffle()
                self?.castCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        detailsViewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("DEBUG PRINT: Error!!!!! \(error)")
                }
            } receiveValue: {[weak self] data in
                self?.similarMovieData = data
                self?.similarMovieData.shuffle()
                self?.similarCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
    }
    
    func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(250)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: Array(repeating: item, count: 3)
        )
        let spacing = CGFloat(8)
        group.interItemSpacing = .fixed(spacing)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 12,
            bottom: 0,
            trailing: 12
        )
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarCollectionView {
            return similarMovieData.count
        } else if collectionView == castCollectionView {
            return movieCastData.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == similarCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MoviesCollectionViewCell.identifier,
                for: indexPath
            ) as! MoviesCollectionViewCell
            let movie = similarMovieData[indexPath.row]
            cell.setupConstraints()
            cell.setup(movie: movie)
            return cell
        } else if collectionView == castCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCollectionViewCell.identifier,
                for: indexPath
            ) as! CastCollectionViewCell
            let cast = movieCastData[indexPath.row]
            cell.setup(cast: cast)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if collectionView == similarCollectionView {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewcontroller = storyboard.instantiateViewController(
                identifier: "DetailViewController"
            ) as! DetailViewController
            viewcontroller.movie = similarMovieData[indexPath.row]
            viewcontroller.modalPresentationStyle = .fullScreen
            viewcontroller.heroModalAnimationType = .fade
            present(viewcontroller, animated: true)
        }
    }
}
