//
//  EpisodeViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var episodeImage: UIImageView!
    
    let summaryPadding:CGFloat = 10
    
    let dataSource = EpisodeDataSource()
    
    lazy var viewModel : EpisodeViewModel = {
        let viewModel = EpisodeViewModel(dataSource: dataSource)
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup UI
        setupUI()
    }
    
    func setupUI() {
        setupLayout()
        
        //update show
        updateShowData()
    }
    
    func setupLayout() {
        summaryTextView.contentInset = UIEdgeInsets(top: summaryPadding, left: summaryPadding, bottom: summaryPadding, right: summaryPadding)
    }
    
    func updateShowData() {
        
        guard let episode = dataSource.data else {
            return
        }
        
        //load URL show image
        if let image = episode.image {
            episodeImage.sd_setImage(with: URL(string: image.medium), placeholderImage: UIImage(named: "placeholder"))
        }
        
        //update show labels
        titleLabel.text = episode.name
        numberLabel.text = episode.numberFormatted()
        seasonLabel.text = episode.seasonFormatted()
        summaryTextView.attributedText = episode.summary?.HTMLToAttributedText
    }
}

