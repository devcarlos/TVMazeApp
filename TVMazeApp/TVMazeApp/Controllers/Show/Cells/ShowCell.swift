//
//  ShowCell.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/25/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit
import SDWebImage

protocol FavoriteShowDelegate: class {
    func didSaveFavorite(show: Show?)
    func handleFavoriteError(error: Error)
}

class ShowCell: UICollectionViewCell {

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var show: Show?
    
    weak var delegate: FavoriteShowDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        favoriteImage.image = favoriteImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        favoriteImage.tintColor = UIColor(hex: "#C1E5E6FF")
        
        ratingImage.image = ratingImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        ratingImage.tintColor = UIColor(hex: "#C1E5E6FF")
    }
    
    func toggle(with favorite:Bool) {
        favoriteImage.tintColor = favorite ? UIColor(hex: "#ffe700ff") : UIColor(hex: "#C1E5E6FF")
    }
    
    public func configure(with show: Show) {
        
        self.show = show
        
        //load URL image
        if let image = show.image {
            showImage.sd_setImage(with: URL(string: image.medium), placeholderImage: UIImage(named: "placeholder"))
        }
        
        show.isFavorite { result in
            self.toggle(with: result)
        }
        
        //update labels
        titleLabel.text = show.name
        ratingLabel.text = show.ratingFormatted()
    }
    
    //MARK: - Favorite Helper Functions
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        toggleFavorite()
    }
    
    func toggleFavorite() {
        
        guard let show = self.show else {
            return
        }
        
        show.isFavorite { result in
            switch result {
            case true:
                FavoriteManager.shared.deleteFavorite(show: show) { result in
                        switch result {
                        case .success:
                            self.delegate?.didSaveFavorite(show: self.show)
                            self.toggle(with: false)
                        case .failure (let error):
                            self.delegate?.handleFavoriteError(error: error)
                        }
                }
            case false:
                FavoriteManager.shared.saveFavorite(show: show) { result in
                    switch result {
                    case .success:
                        self.delegate?.didSaveFavorite(show: nil)
                        self.toggle(with: true)
                    case .failure (let error):
                        self.delegate?.handleFavoriteError(error: error)
                    }
                }
            }
        }
    }
}
