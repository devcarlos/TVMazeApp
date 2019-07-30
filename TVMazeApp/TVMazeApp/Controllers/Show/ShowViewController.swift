//
//  ShowViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

class ShowViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var tableView : UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    let summaryPadding:CGFloat = 10
    
    let dataSource = ShowDataSource()
    
    lazy var viewModel : ShowViewModel = {
        let viewModel = ShowViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        setupActivity()
        setupLayour()
        setupViewModel()
        
        //update show
        updateShowData()
        
        //load show episodes
        loadEpisodes()
    }
    
    func setupTableView() {
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
    }
    
    func setupActivity() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
    }
    
    func setupViewModel() {
        // add error handling example
        viewModel.onErrorHandling = { [weak self] error in
            // display error
            self?.showError(title: "Error occured", message: error?.localizedDescription ?? "Something went wrong, please try again later.")
        }
    }
    
    func setupLayour() {
        
        favoriteImage.image = favoriteImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        favoriteImage.tintColor = UIColor(hex: "#C1E5E6FF")
        
        ratingImage.image = ratingImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        ratingImage.tintColor = UIColor(hex: "#C1E5E6FF")
        
        summaryTextView.contentInset = UIEdgeInsets(top: summaryPadding, left: summaryPadding, bottom: summaryPadding, right: summaryPadding)
    }
    
    func updateShowData() {
        
        guard let show = dataSource.show else {
            return
        }
        
        //load URL show image
        if let image = show.image {
            showImage.sd_setImage(with: URL(string: image.medium), placeholderImage: UIImage(named: "placeholder"))
        }
        
        //update show labels
        titleLabel.text = show.name
        ratingLabel.text = show.ratingFormatted()
        scheduleLabel.text = show.scheduleFormatted()
        genresLabel.text = show.genresFormatted()
        summaryTextView.attributedText = show.summary?.HTMLToAttributedText
    }
    
    func loadEpisodes() {
        activityIndicator.startAnimating()
        
        guard let show = dataSource.show else {
            return
        }
        
        //API fetch episodes
        viewModel.fetchEpisodes(showId: show.id) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ShowViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episode = dataSource.data[indexPath.section].episodes[indexPath.row]
        
        let vc = EpisodeViewController.storyboardViewController()
        vc.dataSource.data = episode
        navigationController?.pushViewController(vc, animated: true)
    }
}
