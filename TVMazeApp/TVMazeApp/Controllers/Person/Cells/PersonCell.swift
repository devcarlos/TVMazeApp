//
//  PersonCell.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/25/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit
import SDWebImage

class PersonCell: UICollectionViewCell {

    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    public func configure(with person: Person) {
        
        //load URL image
        if let image = person.image {
            personImage.sd_setImage(with: URL(string: image.medium), placeholderImage: UIImage(named: "placeholder"))
        }
        
        //update labels
        nameLabel.text = person.name
    }
}
