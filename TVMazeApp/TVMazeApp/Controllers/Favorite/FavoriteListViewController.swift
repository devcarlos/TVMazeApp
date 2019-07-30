//
//  FavoriteListViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit
import PKHUD

class FavoriteListViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var hintLabel: UILabel!
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 20.0,
        bottom: 20.0,
        right: 20.0)
    
    let dataSource = FavoriteListDataSource()
    
    lazy var viewModel : FavoriteListViewModel = {
        let viewModel = FavoriteListViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup UI
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        loadShows()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showInfo(title: "Favorites", message: "Include Favorite Series from listing by click on Favorite Button ❤️")
    }
    
    func setupUI() {
        setupDatasource()
        setupViewModel()
        
        //load shows by default
        loadShows()
    }
    
    func setupDatasource() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self.dataSource
        self.collectionView.register(UINib.init(nibName: "ShowCell", bundle: nil), forCellWithReuseIdentifier: "ShowCell")
    }
    
    func setupViewModel() {
        viewModel.onErrorHandling = { [weak self] error in
            // display error
            self?.showError(title: "Error occured", message: error?.localizedDescription ?? "Something went wrong, please try again later.")
        }
    }
    
    func loadShows() {
        HUD.show(.progress)
        
        //API fetch shows
        viewModel.fetchShows(completion: {
            DispatchQueue.main.async {
                HUD.flash(.success, delay: 0.5)
                self.collectionView.reloadData()
                self.hintLabel.isHidden = self.dataSource.data.count > 0
            }
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let width = availableWidth / itemsPerRow
        let height = width + 165
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let show = dataSource.data[indexPath.row]
        
        let vc = ShowViewController.storyboardViewController()
        vc.dataSource.show = show
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - FavoriteShowDelegate
extension FavoriteListViewController: FavoriteShowDelegate {
    func didSaveFavorite(show: Show?) {
        
        //Update CollectionView after save
        guard let show = show else {
            return
        }
        
        //remove show from collection datasource
        dataSource.data.removeAll { $0.id == show.id }
        
        loadShows()
    }
    
    func handleFavoriteError(error: Error) {
        //handle custom error
        let message = "Error on Update Favorite: \(error.localizedDescription)"
        showError(title: "Favorite Error", message: message)
    }
}
