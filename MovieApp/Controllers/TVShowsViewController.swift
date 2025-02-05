//
//  TVShowsViewController.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 1/31/25.
//

import UIKit
import Combine

class TVShowsViewController: UIViewController {

    @IBOutlet weak var trendingSeriesButton: UIButton!
    @IBOutlet weak var airingTodayButton: UIButton!
    @IBOutlet weak var popularSeriesButton: UIButton!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tvShowsCollectionView: UICollectionView!
    
    var collectionViewData: [Movie] = []
    var buttons: [UIButton] = []
    let tvShowsViewModel = TVShowsViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [trendingSeriesButton, airingTodayButton, popularSeriesButton]
        tvShowsCollectionView
            .register(
                UINib(
                    nibName: MoviesCollectionViewCell.identifier,
                    bundle: nil
                ),
                forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier
            )
        tvShowsCollectionView.collectionViewLayout = setupCompositionalLayout()
        tvShowsCollectionView.refreshControl = UIRefreshControl()
        tvShowsCollectionView.refreshControl?
            .addTarget(
                self,
                action: #selector(didRefreshChanged(_:)),
                for: .valueChanged
            )
        
        setupApi()
    }
    
    @objc func didRefreshChanged(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tvShowsCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    func setupApi() {
        tvShowsViewModel.getPopularTVShows()
        
        tvShowsViewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("DEBUG PRINT: Error!!!!! \(error)")
                }
            } receiveValue: {[weak self] data in
                self?.collectionViewData = data
                self?.tvShowsCollectionView.reloadData()
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
    
    
    @IBAction func tabBarButtonClicked(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else {
            return
        }
        didTabSelected(index)
        
        if index == 0 {
            tvShowsViewModel.getPopularTVShows()
        } else if index == 1 {
            tvShowsViewModel.getairingTodayTVShows()
        } else {
            tvShowsViewModel.getTopRatedTVShows()
        }
        tvShowsCollectionView.reloadData()
//        tvShowsCollectionView
//            .scrollToItem(at: IndexPath(index: 0), at: .top, animated: true)
        tvShowsCollectionView.setContentOffset(.zero, animated: false)
        
        
    }
    
    func didTabSelected(_ index: Int) {
        let selectedButton = buttons[index]
        let isLTR = selectedButton.frame.origin.x > indicatorView.frame.origin.x
        let isRTL = selectedButton.frame.origin.x < indicatorView.frame.origin.x
        if isRTL {
            indicatorViewLeadingConstraint.constant = selectedButton.frame.origin.x
        }
        indicatorViewWidthConstraint.isActive = false
        indicatorViewWidthConstraint = indicatorView.widthAnchor
            .constraint(
                equalToConstant: indicatorView.frame.size.width + selectedButton.frame.size.width
            )
        indicatorViewWidthConstraint.isActive = true
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            if isLTR {
                self.indicatorViewLeadingConstraint.constant = selectedButton.frame.origin.x
            }
            self.indicatorViewWidthConstraint.isActive = false
            self.indicatorViewWidthConstraint = self.indicatorView.widthAnchor
                .constraint(equalToConstant: selectedButton.frame.size.width)
            self.indicatorViewWidthConstraint.isActive = true
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
        for button in buttons {
            button
                .setTitleColor(
                    button == selectedButton ? .accent : .systemGray2,
                    for: .normal
                )
            button.titleLabel?.font = button == selectedButton ?
                .systemFont(ofSize: 15, weight: .bold) :
                .systemFont(ofSize: 14, weight: .regular)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - UICollectionViewDataSource
extension TVShowsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviesCollectionViewCell.identifier,
            for: indexPath
        ) as! MoviesCollectionViewCell
        let movie = collectionViewData[indexPath.row]
        cell.imageContainer.heroID = "moviePosterImage_\(movie.id)"
        cell.hideTitleLabel()
        cell.setup(movie: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TVShowsViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewController(
            identifier: "DetailViewController"
        ) as! DetailViewController
        viewcontroller.movie = collectionViewData[indexPath.row]
        viewcontroller.modalPresentationStyle = .fullScreen
        viewcontroller.heroModalAnimationType = .fade
        present(viewcontroller, animated: true)
    }
}

