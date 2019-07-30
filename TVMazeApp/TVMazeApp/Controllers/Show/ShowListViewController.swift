//
//  ShowListViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit
import PKHUD

class ShowListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView : UICollectionView!

    var searchActive : Bool = false
    
    var paginationActive : Bool = false
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 20.0,
        bottom: 20.0,
        right: 20.0)
    
    let dataSource = ShowListDataSource()
    
    lazy var viewModel : ShowListViewModel = {
        let viewModel = ShowListViewModel(dataSource: dataSource)
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
        
        updateCollection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func updateCollection() {
        //update collection
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupUI() {
        setupDatasource()
        setupViewModel()
        
        hideKeyboardWhenTappedAround()
        
        //load shows by default
        loadShows()
    }
    
    func setupDatasource() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self.dataSource
        self.collectionView.register(UINib.init(nibName: "ShowCell", bundle: nil), forCellWithReuseIdentifier: "ShowCell")
    }
    
    func setupViewModel() {
        // add error handling example
        self.viewModel.onErrorHandling = { [weak self] error in
            // display error
            self?.showError(title: "Error occured", message: error?.localizedDescription ?? "Something went wrong, please try again later.")
        }
    }
    
    func loadShows() {
        HUD.show(.progress)
        
        //API fetch shows
        self.viewModel.fetchShows(completion: {
            DispatchQueue.main.async {
                HUD.flash(.success, delay: 1.0)
                self.updateCollection()
            }
        })
    }
    
    func loadNextPageShows() {
        
        if self.paginationActive {
            return
        }
        
        self.paginationActive = true
        HUD.show(.progress)
        
        //API fetch shows
        self.viewModel.nextPageShows(completion: {
            self.showMessage(title: "Loading Pagination", message: "Loading Shows from page \(self.viewModel.pagination.currentPage)")
            self.paginationActive = false
            DispatchQueue.main.async {
                HUD.flash(.success, delay: 1.0)
                self.updateCollection()
            }
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ShowListViewController : UICollectionViewDelegateFlowLayout {
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

// MARK: - UICollectionViewDelegateFlowLayout
extension ShowListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let show = dataSource.data[indexPath.row]
        
        let vc = ShowViewController.storyboardViewController()
        vc.dataSource.show = show
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            loadNextPageShows()
        }
    }
}

extension ShowListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        dismissKeyboard()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        dismissKeyboard()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        HUD.show(.progress)
        
        if !searchText.isEmpty {
            //reload 1st page shows
            self.viewModel.searchShowsBy(query: searchText) {
                DispatchQueue.main.async {
                    HUD.flash(.success, delay: 1.0)
                    self.collectionView.reloadData()
                }
            }
        } else {
            loadShows()
        }
    }
}

extension ShowListViewController: FavoriteShowDelegate {
    func didSaveFavorite(show: Show?) {
        //update collection
        self.updateCollection()
    }
    
    func handleFavoriteError(error: Error) {
        //handle custom error
        let message = "Error on Update Favorite: \(error.localizedDescription)"
        self.showError(title: "Favorite Error", message: message)
    }
}
