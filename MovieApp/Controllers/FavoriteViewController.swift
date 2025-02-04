//
//  FavoriteViewController.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 1/31/25.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var favoriteSegmentedButton: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteTableView
            .register(
                UINib(
                    nibName: FavoriteTableViewCell.identifier,
                    bundle: nil
                ),
                forCellReuseIdentifier: FavoriteTableViewCell.identifier
            )
    }

}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteTableViewCell.identifier,
            for: indexPath
        ) as! FavoriteTableViewCell
        
        cell.setup(movie: popularData[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        favoriteTableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(140)
//    }
}
