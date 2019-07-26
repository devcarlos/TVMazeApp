//
//  ShowDetailViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

class ShowDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    let dataSource = ShowDetailDataSource()
    
    lazy var viewModel : ShowDetailViewModel = {
        let viewModel = ShowDetailViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup UI
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        setupActivity()
        setupViewModel()
        
        //load shows by default
        loadEpisodes()
    }
    
    func setupTableView() {
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.tableView.register(UINib.init(nibName: EpisodeCell.reuseID, bundle: nil), forCellReuseIdentifier: EpisodeCell.reuseID)
    }
    
    func setupActivity() {
        //activity indicator
        self.view.addSubview(activityIndicator)
        self.activityIndicator.frame = view.bounds
    }
    
    func setupViewModel() {
        // add error handling example
        self.viewModel.onErrorHandling = { [weak self] error in
            // show error message
            let message = "Something went wrong. Error: \(String(describing: error?.localizedDescription))"
            
            let controller = UIAlertController(title: "An error occured", message: message, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self?.present(controller, animated: true, completion: nil)
        }
    }
    
    func loadEpisodes() {
        activityIndicator.startAnimating()
        
        guard let show = dataSource.show else {
            return
        }
        
        //API fetch episodes
        self.viewModel.fetchEpisodes(showId: show.id) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ShowDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
