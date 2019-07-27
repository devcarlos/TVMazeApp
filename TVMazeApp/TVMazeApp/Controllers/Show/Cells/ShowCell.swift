//
//  ShowCell.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/25/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit
import SDWebImage

class ShowCell: UICollectionViewCell {

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        favoriteImage.image = favoriteImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        favoriteImage.tintColor = UIColor(hex: "#C1E5E6FF")
        
        //TODO: yellow for favorite
//        favoriteImage.tintColor = UIColor(hex: "#ffe700ff")
        
        ratingImage.image = ratingImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        ratingImage.tintColor = UIColor(hex: "#C1E5E6FF")
    }
    
    public func configure(with show: Show) {
        
        //load URL image
        if let image = show.image {
            showImage.sd_setImage(with: URL(string: image.medium), placeholderImage: UIImage(named: "placeholder"))
        }
        
        //update labels
        titleLabel.text = show.name
        ratingLabel.text = show.ratingFormatted()
    }
}
