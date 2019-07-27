//
//  ShowListViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit

class ShowListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView : UICollectionView!

    var searchActive : Bool = false
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 20.0,
        bottom: 20.0,
        right: 20.0)
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupUI() {
        setupCollectionView()
        setupActivity()
        setupViewModel()
        
        hideKeyboardWhenTappedAround()
        
        //load shows by default
        loadShows()
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "ShowCell", bundle: nil), forCellWithReuseIdentifier: "ShowCell")
    }
    
    func setupActivity() {
        //activity indicator
        self.view.addSubview(activityIndicator)
        self.activityIndicator.frame = view.bounds
    }
    
    func setupViewModel() {
        // add error handling example
        self.viewModel.onErrorHandling = { [weak self] error in
            // display error ?
            self?.showError(title: "An error occured", message: "Oops, something went wrong!")
        }
    }
    
    func loadShows() {
        activityIndicator.startAnimating()
        
        //API fetch shows
        self.viewModel.fetchShows(completion: {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
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
        
        activityIndicator.startAnimating()
        
        if !searchText.isEmpty {
            //reload 1st page shows
            self.viewModel.searchShowsBy(query: searchText) {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        } else {
            loadShows()
        }
    }
}
