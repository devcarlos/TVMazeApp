//
//  PersonListViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit

class PersonListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var collectionView : UICollectionView!
    
    var searchActive : Bool = false
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 20.0,
        bottom: 20.0,
        right: 20.0)
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    let dataSource = PersonListDataSource()
    
    lazy var viewModel : PersonListViewModel = {
        let viewModel = PersonListViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showInfo(title: "Person Finder", message: "Use the Search Bar to find People starring in shows")
    }
    
    func setupUI() {
        setupCollectionView()
        setupActivity()
        setupViewModel()
        
        hideKeyboardWhenTappedAround()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: PersonCell.reuseID, bundle: nil), forCellWithReuseIdentifier: PersonCell.reuseID)
    }
    
    func setupActivity() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
    }
    
    func setupViewModel() {
        // add error handling example
        viewModel.onErrorHandling = { [weak self] error in
            // display error ?
            self?.showError(title: "An error occured", message: "Oops, something went wrong!")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PersonListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let width = availableWidth / itemsPerRow
        let height = width + 125
        
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
extension PersonListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let person = dataSource.data[indexPath.row]
        let vc = PersonViewController.storyboardViewController()
        vc.dataSource.person = person
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension PersonListViewController: UISearchBarDelegate {
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
        
        //search for person in query
        viewModel.searchPersonsBy(query: searchText) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
                self.hintLabel.isHidden = self.dataSource.data.count > 0
            }
        }
    }
}

