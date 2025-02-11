//
//  FavoriteViewController.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 1/31/25.
//

import UIKit
import CoreData
import Kingfisher

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var favoriteSegmentedButton: UISegmentedControl!
    let context = (
        UIApplication.shared.delegate as! AppDelegate
    ).persistentContainer.viewContext
    var favorites: [Favorite] = []
    var isMovieSegmentSelected: Bool? = nil
    
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()

        favoriteTableView
            .register(
                UINib(
                    nibName: FavoriteTableViewCell.identifier,
                    bundle: nil
                ),
                forCellReuseIdentifier: FavoriteTableViewCell.identifier
            )
        favoriteTableView.refreshControl = UIRefreshControl()
        favoriteTableView.refreshControl?.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        fetchFavorites(isMovie: isMovieSegmentSelected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites(isMovie: isMovieSegmentSelected)
    }
    
    @IBAction func segementButtonPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            isMovieSegmentSelected = true
        } else if sender.selectedSegmentIndex == 2 {
            isMovieSegmentSelected = false
        } else {
            isMovieSegmentSelected = nil
        }
        
        fetchFavorites(isMovie: isMovieSegmentSelected)
    }
    
    @objc func didRefresh() {
        fetchFavorites(isMovie: isMovieSegmentSelected)
        favoriteTableView.refreshControl?.endRefreshing()
    }
    
    func fetchFavorites(isMovie: Bool? = nil) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let data = try context.fetch(request)
            if isMovie != nil {
                favorites = isMovie! ? data
                    .filter { $0.title != nil } : data
                    .filter { $0.title == nil && $0.name != nil }
            } else {
                favorites = data
            }
            favoriteTableView.reloadData()
        } catch {
            print("Error fetch favorites \(error)")
        }
    }
    
    func removeFavorite(with index: Int) {
        context.delete(favorites[index])
        do {
            try context.save()
        } catch {
            print("Unable to remove Favorite \(error)")
        }
        favorites.remove(at: index)
        favoriteTableView.reloadData()
    }

}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteTableViewCell.identifier,
            for: indexPath
        ) as! FavoriteTableViewCell
        
        cell.setup(favorite: favorites[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            identifier: "DetailViewController"
        ) as! DetailViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.heroModalAnimationType = .fade
        viewController.movie = favorites[indexPath.row].asMovie()
        present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(
            style: .destructive,
            title: "Remove"
        ) {[weak self] action, view, _ in
            self?.removeFavorite(with: indexPath.row)
        }
        removeAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [removeAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {[weak self] in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewcontroller = storyboard.instantiateViewController(
                    identifier: "DetailViewController"
                ) as! DetailViewController
                viewcontroller.movie = self?.favorites[indexPath.row].asMovie()
                viewcontroller.modalPresentationStyle = .fullScreen
                viewcontroller.heroModalAnimationType = .fade
                return viewcontroller
            }) { _ in
                let viewDetails = UIAction(
                    title: "View",
                    image: UIImage(systemName: "eye"),
                    identifier: UIAction.Identifier("view")) {[weak self] _ in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewcontroller = storyboard.instantiateViewController(
                            identifier: "DetailViewController"
                        ) as! DetailViewController
                        viewcontroller.modalPresentationStyle = .fullScreen
                        viewcontroller.heroModalAnimationType = .fade
                        viewcontroller.movie = self?.favorites[indexPath.row].asMovie()
                        self?.present(viewcontroller, animated: true)
                    }
                let remove = UIAction(
                    title: "Remove",
                    image: UIImage(systemName: "trash"),
                    identifier: UIAction.Identifier("remove"),
                    attributes: .destructive
                ) {[weak self] _ in
                        self?.removeFavorite(with: indexPath.row)
                    }
                return UIMenu(
                    title: "",
                    image: nil,
                    identifier: nil,
                    children: [viewDetails, remove]
                )
            }
        return configuration
    }
    
    func tableView(
        _ tableView: UITableView,
        willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
        animator: any UIContextMenuInteractionCommitAnimating
    ) {
        if let viewController = animator.previewViewController {
            animator.addAnimations {
                self.present(viewController, animated: true)
            }
        }
    }
}
